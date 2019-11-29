//
//  ControlViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/2/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class ControlTabViewController: UITabBarController {
    
    public static let identifier: String = "ControlTabViewController"

    @IBOutlet weak var mainTabBar: UITabBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = mainTabBar.items {
            for item in items {
                item.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                        NSAttributedString.Key.foregroundColor: UIColor(red: 141/255, green: 153/255, blue: 174/255, alpha: 1)
                    ], for: .normal
                )
                
                item.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.foregroundColor: UIColor.white
                    ], for: UIControl.State.selected
                )
            }
        }
    }
}
