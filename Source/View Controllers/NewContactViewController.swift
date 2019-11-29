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
        
        guard let mail = mailTextField.text else {
            return false
        }
        
        guard !mail.isEmpty else {
            addWarningTo(mailTextField)
            return false
        }
        
        return true
    }
    
    private func addWarningTo(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 0.5
    }
    
    private func removeWarnings() {
        mailTextField.layer.borderColor = UIColor.clear.cgColor
    }
}
