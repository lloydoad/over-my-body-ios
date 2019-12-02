//
//  DummyData.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/15/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

let DUMMY_NOTE_BODY = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing"

let DUMMY_RECIPIENTS_LIST = [
    "joe.mundo@email.com",
    "p.colline@gmail.com",
    "dd@mail.com",
    "kevon@gmail.com",
]

let DUMMY_REQUEST_DATA: [NoteModel] = [
    NoteModel(
        _id: "0",
        subject: "Letter to Loved Ones",
        recipients: [DUMMY_RECIPIENTS_LIST.randomElement() ?? DUMMY_RECIPIENTS_LIST[0]],
        body: DUMMY_NOTE_BODY
    ),
    NoteModel(
        _id: "2",
        subject: "Unsubmitted home assignments",
        recipients: [DUMMY_RECIPIENTS_LIST.randomElement() ?? DUMMY_RECIPIENTS_LIST[0]],
        body: DUMMY_NOTE_BODY
    ),
    NoteModel(
        _id: "1",
        subject: "Accepted Assignments",
        recipients: [DUMMY_RECIPIENTS_LIST.randomElement() ?? DUMMY_RECIPIENTS_LIST[0]],
        body: DUMMY_NOTE_BODY
    ),
    NoteModel(
        _id: "3",
        subject: "Secrets",
        recipients: [DUMMY_RECIPIENTS_LIST.randomElement() ?? DUMMY_RECIPIENTS_LIST[0]],
        body: DUMMY_NOTE_BODY
    )
]

let DUMMY_AUTHORIZATION_KEY: String = "yeetOrYeet"
