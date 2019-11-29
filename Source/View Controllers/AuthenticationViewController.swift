//
//  ViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UIPickerViewDelegate {
    
    // background view
    @IBOutlet weak var backgroundView: UIView!
    
    // label outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    
    // persistent labels
    @IBOutlet weak var usernameLabel: UILabel!
    
    // textfield outlets
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
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
                deadLineLabel.isHidden = false
                deadlineDatePicker.isHidden = false
                
                registerLoginButton.setTitle("Register", for: .normal)
                switchViewButton.setTitle("Switch to Login", for: .normal)
            } else {
                firstNameTextfield.isHidden = true
                lastNameTextField.isHidden = true
                emailTextField.isHidden = true
                firstNameLabel.isHidden = true
                lastNameLabel.isHidden = true
                emailLabel.isHidden = true
                deadlineDatePicker.isHidden = true
                deadLineLabel.isHidden = true
                
                registerLoginButton.setTitle("Login", for: .normal)
                switchViewButton.setTitle("Switch to Register", for: .normal)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickers()
    }
    
    private func setupViews() {
        usernameTextfield.addShadow(width: 0.2)
        firstNameTextfield.addShadow(width: 0.2)
        lastNameTextField.addShadow(width: 0.2)
        emailTextField.addShadow(width: 0.2)
        passwordTextField.addShadow(width: 0.2)
        isRegisteringView = false
    }
    
    private func setupPickers() {
        let nextDay = Date(timeIntervalSinceNow: 60 * 60 * 24)
        deadlineDatePicker.minimumDate = nextDay
    }
    
    @IBAction func registerOrLoginButtonClicked(_ sender: Any) {
        if isRegisteringView {
            registerUser()
        } else {
            loginUser()
        }
    }
    
    private func registerUser() {
//        guard
//            let firstName = self.firstNameTextfield.text, !firstName.isEmpty,
//            let lastName = self.lastNameTextField.text, !lastName.isEmpty,
//            let email = self.emailTextField.text, !email.isEmpty,
//            let username = self.usernameTextfield.text, !username.isEmpty,
//            let password = self.passwordTextField.text, !password.isEmpty
//            else {
//                return
//        }
//
//        let deadlineDate = self.deadlineDatePicker.date
//        let requestBody = [
//            RequestKeys.firstName.rawValue: firstName,
//            RequestKeys.lastName.rawValue: lastName,
//            RequestKeys.username.rawValue: username,
//            RequestKeys.password.rawValue: password,
//            RequestKeys.email.rawValue: email,
//            RequestKeys.deadline.rawValue: dateFormatter.string(from: deadlineDate)
//        ]
        
//        print("register", requestBody)
        RequestSingleton.registerUser(requestBody: [:]) { (viewModel) in
            if let notesViewModel = viewModel {
                self.segueToHomeViewController(model: notesViewModel)
            }
        }
    }
    
    private func loginUser() {
//        guard
//            let username = self.usernameTextfield.text, !username.isEmpty,
//            let password = self.passwordTextField.text, !password.isEmpty
//            else {
//                return
//        }
//
//        let requestBody = [
//            RequestKeys.username.rawValue: username,
//            RequestKeys.password.rawValue: password
//        ]
//
//        print("login", requestBody)
        RequestSingleton.loginUser(requestBudy: [:]) { (viewModel) in
            if let notesViewModel = viewModel {
                self.segueToHomeViewController(model: notesViewModel)
            }
        }
    }
    
    private func segueToHomeViewController(model: [NoteViewModel]) {
        guard let controlTabViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ControlTabViewController.identifier) as? ControlTabViewController else {
            return
        }
        
        controlTabViewController.viewControllers?.forEach({ (viewController) in
            if let homeViewController = viewController as? HomeViewController {
                homeViewController.viewModels = model
            }
        })
        
        self.present(controlTabViewController, animated: true, completion: nil)
    }
    
    @IBAction func switchViewButtonClicked(_ sender: Any) {
        isRegisteringView = !isRegisteringView
    }
}

