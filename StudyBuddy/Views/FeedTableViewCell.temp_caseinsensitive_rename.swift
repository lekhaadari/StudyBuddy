//
//  feedTableViewCell.swift
//  StudyBuddy
//
//  Created by Lekha Adari on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var classNumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
