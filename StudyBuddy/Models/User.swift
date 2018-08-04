//
//  User.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {
    
    // MARK: - Properties
    
    let uid: String
    let username: String
//    let deviceToken: String
    
//    let department: String
//    let subject: String
//    let duration: Double
    
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
 //       self.deviceToken = deviceToken
//        self.department = department
//        self.subject = subject
//        self.duration = duration
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
//            let deviceToken = dict["deviceToken"] as? String
            else { return nil}
//            let department = dict["department"] as? String
//            let subject = dict["subject"] as? String,
//            let duration = dict["duration"] as? Double
//            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
 //       self.deviceToken = deviceToken
        
    }
    
    // From Makestagram
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            if let data = try? JSONEncoder().encode(user) {
                // 4
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }
        
        _current = user
    }
    
   
    
    //EOFM
    
}
