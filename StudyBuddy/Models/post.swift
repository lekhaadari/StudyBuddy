//
//  post.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/25/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    
// properties and initializers
    
   
    let subject: String
    let classNum: String
    let duration: String
    let userID: String
    var postID: String?
    
    
    init(subject: String, classNum: String, duration: String, userID: String) {
        self.subject = subject
        self.classNum = classNum
        self.duration = duration
        self.userID = userID
    }
    
    var dictValue: [String : Any] {
        return ["subject" : subject,
                "classNum" : classNum,
                "duration" : duration,
            "userID": userID]
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let subject = dict["subject"] as? String,
            let classNum = dict["classNum"] as? String,
            let duration = dict["duration"] as? String,
            let userID = dict["userID"] as? String
            else {return nil}
        
       
        self.subject = subject
        self.classNum = classNum
        self.duration = duration
        self.userID = userID
        
    }
}
