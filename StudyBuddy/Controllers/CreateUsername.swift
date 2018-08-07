//
//  CreateUsername.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController : UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameNextButton: UIButton!
    
    @IBAction func usernameCreated(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameNextButton.layer.cornerRadius = 20
        usernameNextButton.layer.masksToBounds = true
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
//        guard let firUser = Auth.auth().currentUser,
//            let username = usernameTextField.text,
//            !username.isEmpty else { return }
//
//        UserService.create(firUser, username: username) { (user) in
//            guard let _ = user else {
//                return
//            }
//
//            let storyboard = UIStoryboard(name: "Main", bundle: .main)
//
//            if let initialViewController = storyboard.instantiateInitialViewController() {
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
//            }
//        }
//    }
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else {
                // handle error
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
}
