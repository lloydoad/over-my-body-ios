//
//  OptionsTableViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/26/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var periodPickerView: UIPickerView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var labelStackView: UIStackView!
    
    
    // dummy date
    let date: Date = Date(timeIntervalSinceNow: 0)
    private let pickerOptions: [String] = [
        "Every day",
        "Every week",
        "Every month",
        "Every 2 months",
        "Every 4 months",
        "Every 8 months",
        "Every year"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.periodPickerView.delegate = self
        self.periodPickerView.dataSource = self
    }
    
    private func setupView() {
        logoutButton.layer.borderColor = UIColor.black.cgColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 8
    }

    // MARK: Picker functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
    }
}
