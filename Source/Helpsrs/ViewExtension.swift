//
//  ViewExtension.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(width: CGFloat) {
        self.layer.borderColor = DARK_GREY.cgColor
        self.layer.borderWidth = width
    }
}
