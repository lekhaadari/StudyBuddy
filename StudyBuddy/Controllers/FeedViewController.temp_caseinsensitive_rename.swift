//
//  feedViewController.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var posts = [Post](){
        didSet{
     //       tableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PostService.show { (allPosts) in
            print(allPosts)
        }
        // call show post
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
