//
//  ContactsViewModel.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/13/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

struct ContactViewModel: Hashable, Equatable, Comparable {
    
    var firstName: String
    var lastName: String
    var email: String
    
    static func == (lhs: ContactViewModel, rhs: ContactViewModel) -> Bool {
        return (
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email
        )
    }
    
    static func < (lhs: ContactViewModel, rhs: ContactViewModel) -> Bool {
        return (
            lhs.lastName < rhs.lastName ||
            lhs.firstName < rhs.firstName ||
            lhs.email < rhs.email
        )
    }
}
