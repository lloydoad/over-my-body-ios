//
//  ViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit
import SVProgressHUD

class AuthenticationViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    // background view
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var authenticationOverlay: UIView!
    
    // label outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    
    // persistent labels
    @IBOutlet weak var usernameLabel: UILabel!
    
    // textfield outlets
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
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
                firstNameLabel.isHidden = false
                lastNameLabel.isHidden = false
                deadLineLabel.isHidden = false
                deadlineDatePicker.isHidden = false
                
                registerLoginButton.setTitle("Register", for: .normal)
                switchViewButton.setTitle("Switch to Login", for: .normal)
            } else {
                firstNameTextfield.isHidden = true
                lastNameTextField.isHidden = true
                firstNameLabel.isHidden = true
                lastNameLabel.isHidden = true
                deadlineDatePicker.isHidden = true
                deadLineLabel.isHidden = true
                
                registerLoginButton.setTitle("Login", for: .normal)
                switchViewButton.setTitle("Switch to Register", for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupViews()
        if AuthorizationToken.getAppToken().0 == nil {
            authenticationOverlay.backgroundColor = .clear
            authenticationOverlay.isHidden = true
        } else {
            authenticationOverlay.backgroundColor = .white
            authenticationOverlay.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let applicationToken = AuthorizationToken.getAppToken()
        SVProgressHUD.show()
        
        guard
            let _ = applicationToken.0,
            let username = applicationToken.2,
            let password = applicationToken.3
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.authenticationOverlay.backgroundColor = .clear
            })
            self.authenticationOverlay.isHidden = true
            SVProgressHUD.dismiss()
            return
        }
        
        let userCredentials = [
            RequestKeys.username.rawValue: username,
            RequestKeys.password.rawValue: password
        ]
        
        RequestSingleton.loginUser(requestBody: userCredentials) { (model) in
            guard let viewModel = model else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.authenticationOverlay.backgroundColor = .clear
                })
                self.authenticationOverlay.isHidden = true
                AuthorizationToken.clearAppToken()
                SVProgressHUD.dismiss()
                return
            }
            
            SVProgressHUD.dismiss()
            self.segueToHomeViewController(model: viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickers()
        self.setupKeyboard()
        self.setupSwipe()
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.authenticationOverlay.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= self.view.frame.height > 690 ? 130 : 105
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func setupViews() {
        usernameTextfield.addShadow(width: 0.2)
        firstNameTextfield.addShadow(width: 0.2)
        lastNameTextField.addShadow(width: 0.2)
        passwordTextField.addShadow(width: 0.2)
        isRegisteringView = false
    }
    
    private func setupPickers() {
        let nextDay = Date(timeIntervalSinceNow: 60 * 25)
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
        guard
            let firstName = self.firstNameTextfield.text, !firstName.isEmpty,
            let lastName = self.lastNameTextField.text, !lastName.isEmpty,
            let username = self.usernameTextfield.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty
            else {
                return
        }
        
        SVProgressHUD.show()
        let deadlineDate = self.deadlineDatePicker.date
        let requestBody = [
            RequestKeys.firstName.rawValue: firstName,
            RequestKeys.lastName.rawValue: lastName,
            RequestKeys.username.rawValue: username,
            RequestKeys.password.rawValue: password,
            RequestKeys.deadline.rawValue: DeadlineFormatter.global.string(from: deadlineDate)
        ]
        
        RequestSingleton.registerUser(requestBody: requestBody) { (viewModel) in
            if let model = viewModel {
                SVProgressHUD.dismiss()
                self.segueToHomeViewController(model: model)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    private func loginUser() {
        guard
            let username = self.usernameTextfield.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty
            else {
                return
        }

        SVProgressHUD.show()
        let requestBody = [
            RequestKeys.username.rawValue: username,
            RequestKeys.password.rawValue: password
        ]

        RequestSingleton.loginUser(requestBody: requestBody) { (viewModel) in
            if let model = viewModel {
                SVProgressHUD.dismiss()
                self.segueToHomeViewController(model: model)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    private func segueToHomeViewController(model: RequestSingleton.UserModel) {
        guard let controlTabViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ControlTabViewController.identifier) as? ControlTabViewController else {
            return
        }
        
        controlTabViewController.viewControllers?.forEach({ (viewController) in
            if let homeViewController = viewController as? HomeViewController {
                homeViewController.viewModels = model.notes
            }
            if let settingsViewController = viewController as? SettingsViewController {
                if let date = DeadlineFormatter.utc.date(from: model.deadline) {
                    settingsViewController.currentDeadline = date
                }
            }
        })
        
        self.present(controlTabViewController, animated: true, completion: nil)
    }
    
    @IBAction func switchViewButtonClicked(_ sender: Any) {
        isRegisteringView = !isRegisteringView
    }
}

