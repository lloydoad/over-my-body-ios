//
//  NotesViewModel.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

struct NoteViewModel {
    
    var subject: String
    var body: String
    var recipients: [String]
    
    var isTemplate: Bool = false
    var index: Int = 0
}
