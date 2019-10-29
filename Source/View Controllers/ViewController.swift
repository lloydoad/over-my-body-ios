//
//  ViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // background view
    @IBOutlet weak var backgroundView: UIView!
    
    // label outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // persistent labels
    @IBOutlet weak var usernameLabel: UILabel!
    
    // textfield outlets
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // buttons
    @IBOutlet weak var registerLoginButton: UIButton!
    @IBOutlet weak var switchViewButton: UIButton!
    
    // state vars
    private var isRegisteringView: Bool = false {
        didSet {
            if self.isRegisteringView {
                firstNameTextfield.isHidden = false
                lastNameTextField.isHidden = false
                emailTextField.isHidden = false
                firstNameLabel.isHidden = false
                lastNameLabel.isHidden = false
                emailLabel.isHidden = false
            } else {
                firstNameTextfield.isHidden = true
                lastNameTextField.isHidden = true
                emailTextField.isHidden = true
                firstNameLabel.isHidden = true
                lastNameLabel.isHidden = true
                emailLabel.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextfield.addShadow(width: 0.2)
        firstNameTextfield.addShadow(width: 0.2)
        lastNameTextField.addShadow(width: 0.2)
        emailTextField.addShadow(width: 0.2)
        passwordTextField.addShadow(width: 0.2)
        
        isRegisteringView = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerOrLoginButtonClicked(_ sender: Any) {
    }
    
    @IBAction func switchViewButtonClicked(_ sender: Any) {
        isRegisteringView = !isRegisteringView
    }
    
}

