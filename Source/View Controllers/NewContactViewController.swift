//
//  NewContactViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var topBarView: UIView!
    
    public static let identifier: String = "NewContactViewController"
    weak var contactsViewController: ContactsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
    }
    
    private func updateTopBarView() {
        self.topBarView.layer.cornerRadius = 16
        self.topBarView.layer.borderWidth = 1.5
        self.topBarView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func addWarningTo(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 0.5
    }
    
    private func removeWarnings() {
        mailTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        removeWarnings()
        
        guard let mail = mailTextField.text, !mail.isEmpty else {
            addWarningTo(mailTextField)
            return
        }
        
        Contacts.saveContact(email: mail) { (didSave) in
            DispatchQueue.main.async {
                if didSave {
                    self.contactsViewController?.fetchContacts()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    if let viewController = self.contactsViewController, !viewController.allEmails.contains(mail) {
                        viewController.allEmails.append(mail)
                        viewController.displayedEmails.append(mail)
                        viewController.contactsTableView.reloadData()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
