//
//  OverMyDeadBodyTests.swift
//  OverMyDeadBodyTests
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import XCTest
@testable import OverMyDeadBody

class OverMyDeadBodyTests: XCTestCase {
    
    var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZGUzMDgwNzJhM2EzYjAwNGM4ZDVlZGEiLCJpYXQiOjE1NzUyNDAwOTAsImV4cCI6MTU3NTI0MTA5MH0.5sW_zIBy4MQUFYLkq4ZvgMEnzETi530-CAHaoFXhHFE"
    var date: Date = Date(timeIntervalSinceNow: 0)
    
    func testRefreshToken() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZGUzMDgwNzJhM2EzYjAwNGM4ZDVlZGEiLCJpYXQiOjE1NzUyMzMwOTAsImV4cCI6MTU3NTIzNDA5MH0.qItTaYGB5f_bwkZgr-_G-T97fNlaFshV9YW0Vio1ajk"
        let tenMinutesAgo = Date(timeIntervalSinceNow: -10 * 60)
        AuthorizationToken.saveToken(token, lastDate: tenMinutesAgo, username: "", password: "")
        
        RequestSingleton.refreshToken() { (didSucceed) in
            if didSucceed {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func setTestAuthorizationToken() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZGU0NjQ2YmMwNmQzYzAwNGI0YjU0ZGIiLCJpYXQiOjE1NzUyNTAyMTUsImV4cCI6MTU3NTI1MTIxNX0.fdZWt3OtmdHy1JqcZy75ICn7sc75kNpePkfWuOOsvTs"
        let tenMinutesAgo = Date(timeIntervalSinceNow: -10 * 60)
        AuthorizationToken.saveToken(token, lastDate: tenMinutesAgo, username: "", password: "")
    }

    func testGettingNotes() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        testLoggingIn()
        RequestSingleton.getNotes { (notes) in
            if let notes = notes {
                print(notes)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func getUserInfo() -> [String:String] {
        return [
            RequestKeys.username.rawValue: "otherUsername",
            RequestKeys.password.rawValue: "password"
        ]
    }
    
    func testLoggingIn() {
        let expectation = XCTestExpectation(description: "Did login user")
        
        RequestSingleton.loginUser(requestBody: getUserInfo()) { (user) in
            DispatchQueue.main.async {
                if let _ = user {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func testRegisterUser() {
        let expectation = XCTestExpectation(description: "Did register user")
        let body = [
            RequestKeys.username.rawValue: randomString(length: 10),
            RequestKeys.password.rawValue: randomString(length: 10),
            RequestKeys.firstName.rawValue: randomString(length: 10),
            RequestKeys.lastName.rawValue: randomString(length: 10),
            RequestKeys.deadline.rawValue: "2020-11-16T19:30+0000"
        ]
        
        RequestSingleton.registerUser(requestBody: body) { (user) in
            DispatchQueue.main.async {
                if let _ = user {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCreateNote() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        
        testLoggingIn()
        let note = NoteViewModel(model: NoteModel(_id: "", subject: "subject", recipients: ["me@email.com"], body: randomString(length: 40)))
        RequestSingleton.createNote(note: note) { (savedNote) in
            DispatchQueue.main.async {
                if let retrievedNote = savedNote {
                    print(retrievedNote)
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSetNote() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        
        testLoggingIn()
        let note = NoteViewModel(model: NoteModel(_id: "5de477d4dd26e4004bfcb9d2", subject: "subject in the future", recipients: ["me@email.com", "new@email.com"], body: randomString(length: 40)))
        
        RequestSingleton.saveNote(note: note) { (savedNote) in
            DispatchQueue.main.async {
                if let retrievedNote = savedNote {
                    print(retrievedNote)
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDeleteNote() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        
        testLoggingIn()
        let note = NoteViewModel(model: NoteModel(_id: "5de47f1fdd26e4004bfcb9d6", subject: "subject in the future", recipients: ["me@email.com", "new@email.com"], body: randomString(length: 40)))
        
        RequestSingleton.deleteNote(note: note) { (didSucceed) in
            DispatchQueue.main.async {
                if didSucceed {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testConfirmLife() {
        let expectation = XCTestExpectation(description: "Did refresh token")
        
        testLoggingIn()
        RequestSingleton.comfirmLife(newDeadline: Date(timeIntervalSinceNow: 60 * 60 * 24 * 5)) { (didSucceed) in
            DispatchQueue.main.async {
                if didSucceed {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
