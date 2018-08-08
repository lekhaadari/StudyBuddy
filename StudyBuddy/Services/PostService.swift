//
//  PostService.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for post: Post, completion: @escaping (Post?)-> Void) {
    let postRef = Database.database().reference().child("posts").childByAutoId()
    
        let postAttr = ["classNum": post.classNum, "duration": post.duration, "userID": User.current.uid , "username": User.current.username, "lat": post.lat, "long": post.long] as [String : Any]
   
    postRef.setValue(postAttr) { (error, ref) in
        if let error = error {
            assertionFailure(error.localizedDescription)
            return completion(nil)
        }
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let post = Post(snapshot: snapshot)
            post?.postID = snapshot.key
            completion(post)
            })
        }
    }
    static func show(completion: @escaping ([Post]?) -> Void) {
        
        let reference = Database.database().reference().child("posts")
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
          var posts = [Post]()
            
            for dbPost in snapshot.children{
  //              print(dbPost)
                guard let post = Post(snapshot: dbPost as! DataSnapshot)  else {
                    return assertionFailure("Failed to get posts from Firebase")
                }
    //            posts.append(post)
                posts.insert(post, at: 0)
            }
            completion(posts)
        }
    }
    
    static func flag(_ post: Post) {
        // 1
        guard let postKey = post.postID else { return }
        
        // 2
        let flaggedPostRef = Database.database().reference().child("flaggedPosts").child(postKey)
        
        // 3
        let flaggedDict = ["post": post.postID,
                           "poster_uid": post.userID,
                           "reporter_uid": User.current.uid]
        
        // 4
        flaggedPostRef.updateChildValues(flaggedDict)
        
        // 5
        let flagCountRef = flaggedPostRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        })
    }
    

}




