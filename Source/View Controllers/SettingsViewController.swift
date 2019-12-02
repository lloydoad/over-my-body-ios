//
//  OptionsTableViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/26/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit
import SVProgressHUD

class SettingsViewController: UIViewController {

    @IBOutlet weak var currentDeadlineLabel: UILabel!
    @IBOutlet weak var deadlinePickerView: UIDatePicker!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        return formatter
    }
    
    internal var isCountingDown: Bool = false {
        didSet {
            guard timeRemainingLabel != nil && checkInButton != nil else {
                return
            }
            
            if isCountingDown {
                timeRemainingLabel.isHidden = false
                checkInButton.isHidden = false
            } else {
                timeRemainingLabel.isHidden = true
                checkInButton.isHidden = true
            }
        }
    }
    
    var currentDeadline: Date = Date(timeIntervalSinceNow: 60 * 25)
    let currentDeadlineLabelFormat: String = "Current Set Deadline: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        let next30Minutes = Date(timeIntervalSinceNow: 60 * 25)
        self.deadlinePickerView.minimumDate = next30Minutes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateSettingValues()
    }
    
    private func setupView() {
        logoutButton.layer.borderColor = UIColor.black.cgColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 8
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 8
        checkInButton.layer.borderColor = UIColor.black.cgColor
        checkInButton.layer.borderWidth = 1
        checkInButton.layer.cornerRadius = 8
    }
    
    public func updateSettingValues() {
        let difference = self.currentDeadline.timeIntervalSince1970 - Date(timeIntervalSinceNow: 0).timeIntervalSince1970
        self.isCountingDown = difference <= (60 * 30)
        self.updateCountdown(timeRemaining: difference)
        self.deadlinePickerView.date = self.currentDeadline
        self.currentDeadlineLabel.text = "\(currentDeadlineLabelFormat)\(dateFormatter.string(from: self.currentDeadline))"
    }
    
    var currentCountDownTime: TimeInterval = 30
    
    public func updateCountdown(timeRemaining: TimeInterval) {
        guard timeRemaining <= (60 * 30) else {
            return
        }
        
        guard timeRemaining > -1 else {
            return
        }
        
        self.currentCountDownTime = timeRemaining
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: isCountingDown)
    }
    
    @objc private func updateTimer() {
        guard self.currentCountDownTime > 0 else {
            return
        }
        
        let minutes = currentCountDownTime / 60
        self.currentCountDownTime -= 1
        self.timeRemainingLabel.text = "\(Int(minutes)) \(minutes > 1 ? "minutes" : "minute") remaining"
    }
    
    @IBAction func checkInButtonTapped(_ sender: Any) {
        let nextDeadline = Date(timeIntervalSinceNow: 60 * 60 * 24 * 14)
        RequestSingleton.comfirmLife(newDeadline: nextDeadline) { (didConfirm) in
            guard didConfirm else {
                return
            }
            
            self.currentDeadline = nextDeadline
            self.updateSettingValues()
            DeadlineNotifications.scheduleNotificationsFor(nextDeadline)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let nextDeadline = self.deadlinePickerView.date
        guard nextDeadline != self.currentDeadline else {
            return
        }
        
        SVProgressHUD.show()
        RequestSingleton.comfirmLife(newDeadline: nextDeadline) { (didConfirm) in
            guard didConfirm else {
                SVProgressHUD.showError(withStatus: nil)
                SVProgressHUD.dismiss()
                return
            }
            
            self.currentDeadline = nextDeadline
            self.updateSettingValues()
            DeadlineNotifications.scheduleNotificationsFor(nextDeadline)
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        AuthorizationToken.clearAppToken()
        self.dismiss(animated: true, completion: nil)
    }
}
