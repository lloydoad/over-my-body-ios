//
//  RequestSingleton.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/15/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public enum RequestKeys: String {
    case recipients
    case firstName
    case lastName
    case username
    case password
    case deadline
    case interval
    case subject
    case email
    case body
    case _id
}

public var authorizationToken: String? = nil

public final class RequestSingleton {
    
    public static let DefaultURL: URL? = URL(string: "someurl")
    
    public static func registerUser(requestBody: [String:String], completion: @escaping ([NoteViewModel]?) -> ()) {
        let loginRequestBody = [
            RequestKeys.username.rawValue: requestBody[RequestKeys.username.rawValue]!,
            RequestKeys.password.rawValue: requestBody[RequestKeys.password.rawValue]!
        ]
        
        loginUser(requestBudy: loginRequestBody) { (results) in
            completion(results)
        }
    }
    
    public static func loginUser(requestBudy: [String:String], completion: @escaping ([NoteViewModel]?) -> ()) {
        getNotes { (results) in
            completion(results)
        }
    }
    
    public static func getNotes(completion: @escaping ([NoteViewModel]?) -> ()) {
        // use token to get request
        completion(DUMMY_REQUEST_DATA.map { NoteViewModel.init(model: $0) })
    }
    
    public static func saveNote(note: NoteViewModel, completion: @escaping (NoteViewModel?) -> ()) {
        let requestBody: [String:Any] = [
            RequestKeys._id.rawValue: note.id,
            RequestKeys.subject.rawValue: note.subject,
            RequestKeys.recipients.rawValue: note.recipients,
            RequestKeys.body.rawValue: note.body
        ]
        print(requestBody)
        completion(note)
    }
    
    public static func createNote(note: NoteViewModel, completion: @escaping (NoteViewModel?) -> ()) {
        let requestBody: [String:Any] = [
            RequestKeys.subject.rawValue: note.subject,
            RequestKeys.recipients.rawValue: note.recipients,
            RequestKeys.body.rawValue: note.body
        ]
        print(requestBody)
        completion(note)
    }
}


