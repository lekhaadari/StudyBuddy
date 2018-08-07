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
    
   
///    let subject: String
    let classNum: String
    let duration: String
   // var user: String?
    let userID: String
   let userName: String?
    var postID: String?
    var lat: Double?
    var long: Double?
    
    
    init(classNum: String, duration: String, user: User, lat: Double, long: Double) {
//        self.subject = subject
        self.classNum = classNum
        self.duration = duration
       // self.user = user
        self.userID = user.uid
        self.userName = user.username
        self.lat = lat
        self.long = long
    }
    
    var dictValue: [String : Any] {
        return ["classNum" : classNum,
                "duration" : duration,
                "userID": userID,
                "lat": lat,
                "long": long
               
        ]
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
  //          let subject = dict["subject"] as? String,
            let classNum = dict["classNum"] as? String,
            let duration = dict["duration"] as? String,
//            let user = dict["user"] as? User,
            let userID = dict["userID"] as? String,
            let userName = dict["username"] as? String,
            let lat = dict["lat"] as? Double,
            let long = dict["long"] as? Double
            else {return nil}
        
       self.postID = snapshot.key
//        self.subject = subject
        self.classNum = classNum
        self.duration = duration
//        self.user = user
        self.userID = userID
        self.userName = userName
        self.lat = lat
        self.long = long
        
    }
}
