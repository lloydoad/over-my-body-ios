//
//  ContactsTableViewCell.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let identifier: String = "ContactCellIdentifier"
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    var shouldDisplaySelectedBackground: Bool = false {
        didSet {
            if shouldDisplaySelectedBackground {
                customBackgroundView.backgroundColor = .gray
            } else {
                customBackgroundView.backgroundColor = .white
            }
        }
    }
    
    var email: String? {
        didSet {
            guard let email = self.email else {
                return
            }
            emailLabel.text = email
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customBackgroundView.layer.borderWidth = 1
        customBackgroundView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {    }
        
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {     }
}
