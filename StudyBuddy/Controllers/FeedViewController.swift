//
//  feedViewController.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: - Properties
    
    var posts = [Post](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(posts.count)
        print("Posts from FeedViewController: \(posts)")
        
//        tableView.delegate = self
//        tableView.dataSource = self 
        // Do any additional setup after loading the view.
        
        // Check for UID, if UID == userdefaults UID
        // Don't show that user, or pop that user from the array of users
        PostService.show { (allPosts) in
            print(allPosts?.count)
            print("All Posts From Firebase: \(allPosts)")
            
            self.posts = allPosts!
            print(self.posts.count)
            print("Posts from FeedViewController: \(self.posts)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        PostService.show { (allPosts) in
//            print(allPosts)
//        }
        // call show post
    }

    
// // NEW - CHECK THIS - USERNAME BUTTON
//    @IBAction func usernameButton(_ sender: Any) {
//        var chatMembers = [User]()
//        chatMembers.append(User.current)
//        //append selected user
//        let chatHash = Chat.hash(forMembers: chatMembers)
//    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCell", for: indexPath) as! FeedTableViewCell
            
            let post = posts[indexPath.row]
            
            DispatchQueue.global().async {
                UserService.show(forUID: post.userID, completion: { (user) in
                    DispatchQueue.main.async {
                        //cell.usernameButton.titleLabel?.text = user?.username
                        cell.usernameButton.setTitle(user?.username, for: .normal)
                    }
                })
            }
           
    //        cell.usernameLabel.text = post.userID
            cell.subjectLabel.text = post.subject
            cell.classNumLabel.text = post.classNum
            cell.durationLabel.text = post.duration
            //        // 3
            //        cell.lastModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown"
    
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        
        DispatchQueue.global().async {
            UserService.show(forUID: post.userID, completion: { (user) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "chat", sender: user)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat"{
        let chatVC = segue.destination as! ChatViewController
        let user = sender as! User
        chatVC.secondUser = user
        }
        
    }
}




















