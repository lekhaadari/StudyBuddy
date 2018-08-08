//
//  ChatService.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/27/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChatService {
    
    static func create(from message: Message, with chat: Chat, completion: @escaping (Chat?) -> Void) {
        
        // 1
        var membersDict = [String : Bool]()
        for uid in chat.memberUIDs {
            membersDict[uid] = true
        }
        
        // 2
        let lastMessage = "\(message.sender.username): \(message.content)"
        chat.lastMessage = lastMessage
        let lastMessageSent = message.timestamp.timeIntervalSince1970
        chat.lastMessageSent = message.timestamp
        
        // 3
        let chatDict: [String : Any] = ["title" : chat.title,
                                        "memberHash" : chat.memberHash,
                                        "members" : membersDict,
                                        "lastMessage" : lastMessage,
                                        "lastMessageSent" : lastMessageSent]
        
        // 4
        let chatRef = Database.database().reference().child("chats").child(User.current.uid).childByAutoId()
        chat.key = chatRef.key
        
        // 5
        var multiUpdateValue = [String : Any]()
        
        // 6
        for uid in chat.memberUIDs {
            multiUpdateValue["chats/\(uid)/\(chatRef.key)"] = chatDict
        }
        
        // 7
        let messagesRef = Database.database().reference().child("messagess").child(chatRef.key).childByAutoId()
        let messageKey = messagesRef.key
        
        // 8
        multiUpdateValue["messagess/\(chatRef.key)/\(messageKey)"] = message.dictValue
        
        // 9
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            completion(chat)
        }
    
}
    static func checkForExistingChat(with user: User, completion: @escaping (Chat?) -> Void) {
        // 1
        let members = [user, User.current]
        let hashValue = Chat.hash(forMembers: members)
        
        // 2
        let chatRef = Database.database().reference().child("chats").child(User.current.uid)
        
        // 3
        let query = chatRef.queryOrdered(byChild: "memberHash").queryEqual(toValue: hashValue)
        
        // 4
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let chatSnap = snapshot.children.allObjects.first as? DataSnapshot,
                let chat = Chat(snapshot: chatSnap)
                else { return completion(nil) }
            
            completion(chat)
        })
    }
    
    static func sendMessage(_ message: Message, for chat: Chat, success: ((Bool) -> Void)? = nil) {
        guard let chatKey = chat.key else {
            success?(false)
            return
        }
        
        var multiUpdateValue = [String : Any]()
        
        for uid in chat.memberUIDs {
            let lastMessage = "\(message.sender.username): \(message.content)"
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessage"] = lastMessage
            multiUpdateValue["chats/\(uid)/\(chatKey)/lastMessageSent"] = message.timestamp.timeIntervalSince1970
        }
        
        let messagesRef = Database.database().reference().child("messagess").child(chatKey).childByAutoId()
        let messageKey = messagesRef.key
        multiUpdateValue["messagess/\(chatKey)/\(messageKey)"] = message.dictValue
        
        let rootRef = Database.database().reference()
        rootRef.updateChildValues(multiUpdateValue, withCompletionBlock: { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success?(false)
                return
            }
            
            success?(true)
        })
    }
    
    static func flag(_ chat: Chat) {
        // 1
        guard let chatKey = chat.key else { return }
        
        // 2
        let flaggedChatRef = Database.database().reference().child("flaggedChats").child(chatKey)
        
        // 3
        var chatterUID = ""
        if chat.memberUIDs.first == User.current.uid {
            chatterUID = chat.memberUIDs.last!
        }
        else {
            chatterUID = chat.memberUIDs.first!
        }
        let flaggedDict = ["chatID": chat.key,
                           "chatter_uid": chatterUID,
                           "reporter_uid": User.current.uid]
        
        // 4
        flaggedChatRef.updateChildValues(flaggedDict)
        
        // 5
        let flagCountRef = flaggedChatRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        })
    }
    
    
    static func observeMessages(forChatKey chatKey: String, completion: @escaping (DatabaseReference, Message?) -> Void) -> DatabaseHandle {
        let messagesRef = Database.database().reference().child("messagess").child(chatKey)
        
        return messagesRef.observe(.childAdded, with: { snapshot in
            guard let message = Message(snapshot: snapshot) else {
                return completion(messagesRef, nil)
            }
            
            completion(messagesRef, message)
        })
    }
}
