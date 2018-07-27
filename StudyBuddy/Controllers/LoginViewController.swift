//
//  LoginViewController.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        // 2
        authUI.delegate = self
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do any additional set-up after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //dispose of any resources that can be recreated
    }
    
    
    
    /*
     In a storyboard application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     get the new view controller using : segue.destinationViewController
     pass the selected object to the new view controller
    }
     
  */

}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }

        // 1
        guard let user = authDataResult?.user
            else { return }

        // 2
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                // handle new user
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        }
}

}
