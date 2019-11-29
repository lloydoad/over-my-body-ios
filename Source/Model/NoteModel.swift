//
//  NoteModel.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/15/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public struct NoteModel: Codable {
    var _id: String
    var subject: String
    var recipients: [String]
    var body: String
    
    public init(_id: String, subject: String, recipients: [String], body: String) {
        self._id = _id
        self.subject = subject
        self.recipients = recipients
        self.body = body
    }
}
