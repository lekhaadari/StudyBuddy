//
//  feedViewController.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class FeedViewController: UIViewController, CLLocationManagerDelegate {
    
let locationManager = CLLocationManager()

    // MARK: - Properties
    var existingChat: Chat?
    var posts = [Post](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var postsHandle: DatabaseHandle = 0
    var postsRef: DatabaseReference?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: View's Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locations.last
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(posts.count)
        print("Posts from FeedViewController: \(posts)")
        
//        tableView.delegate = self
//        tableView.dataSource = self 
        // Do any additional setup after loading the view.
        
        // Check for UID, if UID == userdefaults UID
        // Don't show that user, or pop that user from the array of users
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        PostService.show { (allPosts) in
            print(allPosts?.count)
            print("All Posts From Firebase: \(allPosts)")
            
            self.posts = allPosts!
            print(self.posts.count)
            print("Posts from FeedViewController: \(self.posts)")
        }
//        tableView.tableFooterView = UIView()
        postsHandle = UserService.observePosts { [weak self] (ref, posts) in
            self?.postsRef = ref
//            self?.posts = posts
            var tempPost = [Post]()
            for post in posts {
                let postLocation = CLLocation.init(latitude: post.lat!, longitude: post.long!)
                let distance = postLocation.distance(from: (self?.locationManager.location!)!)
                print (distance)
                if (distance < 2) {
                    tempPost.insert(post, at: 0)
                }
            }
            
            
            self?.posts = tempPost

            // 3
            self?.tableView.rowHeight = 125
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
////        PostService.show { (allPosts) in
////            print(allPosts)
////        }
//        // call show post
////        tableView.reloadData()
//    }

    
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
                        //cell.usernameButton.setTitle(user?.username, for: .normal)
                    }
                })
            }
           
            cell.usernameLabel.text = post.userName
  //          cell.subjectLabel.text = post.subject
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
                ChatService.checkForExistingChat(with: user!, completion: { (chat) in
                    DispatchQueue.main.async {
                        self.existingChat = chat
                        self.performSegue(withIdentifier: "chat", sender: user)
                    }
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let postToDelete = notes[indexPath.row]
//            CoreDataHelper.delete(note: noteToDelete)
            
//            notes = CoreDataHelper.retrieveNotes()
            let postToDelete = posts[indexPath.row]
            let user = User.current
            if postToDelete.userName == user.username {
                let postRef = Database.database().reference().child("posts").child(postToDelete.postID!)
                postRef.removeValue() { (error, postToDelete) in
                if error != nil {
                    print(error)
                    return
                }
                print("Posts Deleted")
            }
//            postRef.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            posts.remove(at: indexPath.row)
            tableView.reloadData()
        }
            else {
                print("cant delete other's posts")
            }
        }
    }
    
//    guard let selectedUser = selectedUser else { return }
//
//    // 2
//    sender.isEnabled = false
//    // 3
//    ChatService.checkForExistingChat(with: selectedUser) { (chat) in
//    // 4
//    sender.isEnabled = true
//    self.existingChat = chat
//
//    self.performSegue(withIdentifier: "toChat", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chat"{
        let chatVC = segue.destination as! ChatViewController
        let user = sender as! User
        chatVC.secondUser = user
            
        //check this code pls
             let members = [User.current, user]
        chatVC.chat = self.existingChat ?? Chat(members: members)
            // ALSO CHECK THIS CODE PLS
       
        
        }
        
    }
}





















