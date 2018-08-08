//
//  ChatTableViewCell.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/27/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        didTapOptionsButtonForCell?(self)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    var didTapOptionsButtonForCell: ((ChatListCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
