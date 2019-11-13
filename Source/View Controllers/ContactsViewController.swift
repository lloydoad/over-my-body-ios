//
//  ContactsViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var addNewEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
        self.updateRecipientsButton()
    }
    
    private func updateRecipientsButton() {
        self.addNewEmailButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addNewEmailButton.layer.borderWidth = 0.5
        self.addNewEmailButton.layer.cornerRadius = 8
        self.addNewEmailButton.setTitleColor(.black, for: .highlighted)
    }
    
    private func updateTopBarView() {
        self.topBarView.layer.cornerRadius = 16
        self.topBarView.layer.borderWidth = 1.5
        self.topBarView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    @IBAction func unwindToContactsViewController(segue: UIStoryboardSegue) {
        
    }
}
