//
//  feedTableViewCell.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    
 //   @IBOutlet weak var usernameButton: UIButton!
    //    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var classNumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var subjectLabel: UILabel!
//    @IBOutlet weak var classNumLabel: UILabel!
//    @IBOutlet weak var durationLabel: UILabel!
    
//    @IBAction func usernameButtonTapped(_ sender: Any) {
//        print(usernameButton.titleLabel)
//        // make selected user = the username button that we clicked
////        guard let selectedUser = selectedUser else { return }
//        
//        // 2
////        sender.isEnabled = false
//        // 3
////        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
//            // 4
////            sender.isEnabled = true
////            self.existingChat = chat
//            
////            self.performSegue(withIdentifier: "toChat", sender: self)
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
