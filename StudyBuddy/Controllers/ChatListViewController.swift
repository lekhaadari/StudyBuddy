//
//  ChatListViewController.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/27/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatListViewController: UIViewController {
//
    var chats = [Chat]()
//    
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?
//
    @IBOutlet weak var tableView: UITableView!
//    
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Do any additional setup after loading the view.
//        tableView.rowHeight = 71
//        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        userChatsHandle = UserService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            var tempChat = [Chat]()
            for chat in chats {
                tempChat.insert(chat, at: 0)
            }
            self?.chats = tempChat
            
            // 3
            self?.tableView.rowHeight = 125
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
//    
    deinit {
        // 4
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
}
extension ChatListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        return chats.count
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell") as! ChatListCell
//
        let chat = chats[indexPath.row]
        cell.titleLabel.text = chat.title
        cell.lastMessageLabel.text = chat.lastMessage
//
      return cell
    
}
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chat", sender: self)
    }
}

// MARK: - Navigation

extension ChatListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "chat",
            let destination = segue.destination as? ChatViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            destination.chat = chats[indexPath.row]
        }
    }
}
