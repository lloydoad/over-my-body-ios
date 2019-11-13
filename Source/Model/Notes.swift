//
//  Notes.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/3/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

struct Note: Codable {
    var subject: String
    var body: String
    var recipients: [String]
}

let dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing"
let dummyEmails = [
    "joe.smith@email.com",
    "jim.smith@gmail.com",
    "john@email.com",
    "jill@email.com"
]

let dummyData = [
    Note(subject: "Will And Testament to Children", body: dummyText, recipients: dummyEmails),
    Note(subject: "printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting", body: dummyText, recipients: dummyEmails),
    Note(subject: "Lorem Ipsum passages", body: dummyText, recipients: dummyEmails),
    Note(subject: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", body: dummyText, recipients: dummyEmails),
    Note(subject: "printer took a galley of specimen book. It has survived not only five centuries, but also the leap into electronic typesetting", body: dummyText, recipients: dummyEmails)
]
