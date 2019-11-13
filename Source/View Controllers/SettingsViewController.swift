//
//  SettingsViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/2/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var settingsTabBarItem: UITabBarItem!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.borderColor = UIColor(red: 141/255, green: 153/255, blue: 174/255, alpha: 1).cgColor
        logoutButton.layer.borderWidth = 1
    }
}
