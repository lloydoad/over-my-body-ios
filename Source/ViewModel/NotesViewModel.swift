//
//  NotesViewModel.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public struct NoteViewModel {
    var id: String
    var body: String
    var subject: String
    var recipients: [String]
    
    var isTemplate: Bool = false
    
    public init(model: NoteModel) {
        self.id = model._id
        self.body = model.body
        self.subject = model.subject
        self.recipients = model.recipients
    }
}
