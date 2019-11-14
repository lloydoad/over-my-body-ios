//
//  NewContactViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var topBarView: UIView!
    
    var contact: ContactViewModel = ContactViewModel(firstName: "", lastName: "", email: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
    }
    
    private func updateTopBarView() {
        self.topBarView.layer.cornerRadius = 16
        self.topBarView.layer.borderWidth = 1.5
        self.topBarView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        removeWarnings()
        guard identifier == "saveIdentifier" else {
            return true
        }
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let mail = mailTextField.text else {
            return false
        }
        
        guard !firstName.isEmpty || !lastName.isEmpty else {
            if firstName.isEmpty {
                addWarningTo(firstNameTextField)
            } else {
                addWarningTo(lastNameTextField)
            }
            return false
        }
        
        guard !mail.isEmpty else {
            addWarningTo(mailTextField)
            return false
        }
        
        self.contact = ContactViewModel(firstName: firstName, lastName: lastName, email: mail)
        return true
    }
    
    private func addWarningTo(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 0.5
    }
    
    private func removeWarnings() {
        firstNameTextField.layer.borderColor = UIColor.clear.cgColor
        lastNameTextField.layer.borderColor = UIColor.clear.cgColor
        mailTextField.layer.borderColor = UIColor.clear.cgColor
    }
}
