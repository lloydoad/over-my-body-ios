//
//  RequestSingleton.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/15/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public enum RequestKeys: String {
    case Authorization
    case recipients
    case firstName
    case lastName
    case username
    case password
    case deadline
    case interval
    case subject
    case email
    case noteBody
    case _id
}

public enum RequestURLS: String {
    case login = "https://www.overmydeadbody.tech/users/login"
    case register = "https://www.overmydeadbody.tech/users/register"
    case refreshToken = "https://www.overmydeadbody.tech/refreshToken"
    case getNotes = "https://www.overmydeadbody.tech/notes/getNotes"
    case createNote = "https://www.overmydeadbody.tech/notes/createNote"
    case setNote = "https://www.overmydeadbody.tech/notes/setNote"
    case deleteNote = "https://www.overmydeadbody.tech/notes/deleteNote"
    case confirmLife = "https://www.overmydeadbody.tech/users/confirmLife"
}

public final class RequestSingleton {
    
    public static func registerUser(requestBody: [String:String], completion: @escaping (UserModel?) -> ()) {
        
        guard
            let username = requestBody[RequestKeys.username.rawValue],
            let password = requestBody[RequestKeys.password.rawValue]
        else {
            completion(nil)
            return
        }
        
        guard
            let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody),
            let url = URL(string: RequestURLS.register.rawValue)
        else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = jsonRequestBody
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil)
                    return
                }
                
                guard let userData = try? JSONDecoder().decode(LoginModel.self, from: data) else {
                    completion(nil)
                    return
                }
                
                AuthorizationToken.saveToken(userData.token, lastDate: Date(timeIntervalSinceNow: 0), username: username, password: password)
                getNotes { (results) in
                    guard let notes = results else {
                        completion(nil)
                        return
                    }
                    
                    let user = UserModel(token: userData.token, deadline: userData.deadline, notes: notes)
                    completion(user)
                }
            }
        }
        
        task.resume()
    }
    
    public struct UserModel {
        var token: String
        var deadline: String
        var notes: [NoteViewModel]
    }
    
    public struct LoginModel: Codable {
        var token: String
        var deadline: String
    }
    
    public static func loginUser(requestBody: [String:String], completion: @escaping (UserModel?) -> ()) {
        
        guard
            let username = requestBody[RequestKeys.username.rawValue],
            let password = requestBody[RequestKeys.password.rawValue]
        else {
            completion(nil)
            return
        }
        
        guard
            let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody),
            let url = URL(string: RequestURLS.login.rawValue)
        else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = jsonRequestBody
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil)
                    return
                }
                
                guard let userData = try? JSONDecoder().decode(LoginModel.self, from: data) else {
                    completion(nil)
                    return
                }
                
                AuthorizationToken.saveToken(userData.token, lastDate: Date(timeIntervalSinceNow: 0), username: username, password: password)
                getNotes { (results) in
                    guard let notes = results else {
                        completion(nil)
                        return
                    }
                    
                    let user = UserModel(token: userData.token, deadline: userData.deadline, notes: notes)
                    completion(user)
                }
            }
        }
        
        task.resume()
    }
    
    public static func getNotes(completion: @escaping ([NoteViewModel]?) -> ()) {
        refreshToken { (didSucceed) in
            guard
                didSucceed,
                let url = URL(string: RequestURLS.getNotes.rawValue),
                let authorizationToken = AuthorizationToken.getAppToken().0
            else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(authorizationToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil)
                        return
                    }
                    
                    guard let notes = try? JSONDecoder().decode([NoteModel].self, from: data) else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    
                    completion(notes.map { NoteViewModel.init(model: $0) })
                    return
                }
            }
            
            task.resume()
        }
    }
    
    public static func saveNote(note: NoteViewModel, completion: @escaping (NoteViewModel?) -> ()) {
        refreshToken { (didSucceed) in
            
            let requestBody: [String:Any] = [
                RequestKeys._id.rawValue: note.id,
                RequestKeys.subject.rawValue: note.subject,
                RequestKeys.recipients.rawValue: note.recipients,
                RequestKeys.noteBody.rawValue: note.body
            ]
            
            guard
                didSucceed,
                let url = URL(string: RequestURLS.setNote.rawValue),
                let authorizationToken = AuthorizationToken.getAppToken().0,
                let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
            else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(authorizationToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
            request.httpBody = jsonRequestBody
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil)
                        return
                    }
                    
                    guard
                        let model = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                        model["message"] == "Update successful."
                    else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    
                    completion(note)
                    return
                }
            }
            
            task.resume()
        }
    }
    
    struct NoteResponse: Codable {
        var message: String
        var note: NoteModel
    }
    
    public static func createNote(note: NoteViewModel, completion: @escaping (NoteViewModel?) -> ()) {
        refreshToken { (didSucceed) in
            let requestBody: [String:Any] = [
                RequestKeys.subject.rawValue: note.subject,
                RequestKeys.recipients.rawValue: note.recipients,
                RequestKeys.noteBody.rawValue: note.body
            ]
            
            guard
                didSucceed,
                let url = URL(string: RequestURLS.createNote.rawValue),
                let authorizationToken = AuthorizationToken.getAppToken().0,
                let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
            else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(authorizationToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
            request.httpBody = jsonRequestBody
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil)
                        return
                    }
                    
                    guard let response = try? JSONDecoder().decode(NoteResponse.self, from: data) else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    
                    completion(NoteViewModel(model: response.note))
                    return
                }
            }
            
            task.resume()
        }
    }
    
    public static func deleteNote(note: NoteViewModel, completion: @escaping (Bool) -> ()) {
        refreshToken { (didSucceed) in
           
            let requestBody: [String:Any] = [
                RequestKeys._id.rawValue: note.id
            ]
            
            guard
                didSucceed,
                let url = URL(string: RequestURLS.deleteNote.rawValue),
                let authorizationToken = AuthorizationToken.getAppToken().0,
                let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
            else {
                completion(false)
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(authorizationToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
            request.httpBody = jsonRequestBody
            request.httpMethod = "DELETE"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(false)
                        return
                    }
                    
                    guard
                        let model = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                        model["message"] == "Successfully deleted note."
                    else {
                        print("Decoding error")
                        completion(false)
                        return
                    }
                    
                    completion(true)
                    return
                }
            }
            
            task.resume()
        }
    }
    
    public static func comfirmLife(newDeadline: Date, completion: @escaping (Bool) -> ()) {
        refreshToken { (didSucceed) in
            
            let requestBody: [String:Any] = [
                RequestKeys.deadline.rawValue: DeadlineFormatter.global.string(from: newDeadline),
            ]

            guard
                didSucceed,
                let url = URL(string: RequestURLS.confirmLife.rawValue),
                let authorizationToken = AuthorizationToken.getAppToken().0,
                let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
            else {
                completion(false)
                return
            }

            var request = URLRequest(url: url)
            request.setValue(authorizationToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
            request.httpBody = jsonRequestBody
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(false)
                        return
                    }

                    guard
                        let model = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                        model["newDeadline"] != nil
                    else {
                        print("Decoding error")
                        completion(false)
                        return
                    }
                    
                    let serverDate = model["newDeadline"]!
                    let newD = DeadlineFormatter.utc.date(from: serverDate)
                    
                    print(newDeadline)
                    print(newD!)
                    print(newD == newDeadline)
                    completion(true)
                }
            }
            
            task.resume()
        }
    }
    
    public static func refreshToken(token: String? = nil, completion: @escaping (Bool) -> ()) {
        
        let applicationToken = AuthorizationToken.getAppToken()
        
        var bearerToken = "Bearer "
        if let token = token {
            bearerToken += token
        } else if let token = applicationToken.0 {
            bearerToken += token
        } else {
            completion(false)
            return
        }
        
        guard let date = applicationToken.1 else {
            completion(false)
            return
        }
        
        let timeSinceLastUpdate = abs(date.timeIntervalSinceNow)
        guard timeSinceLastUpdate >= 60 * 15 else {
            completion(true)
            return
        }
        
        completion(true)
//        guard let url = URL(string: RequestURLS.refreshToken.rawValue) else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue(bearerToken, forHTTPHeaderField: RequestKeys.Authorization.rawValue)
//        request.httpMethod = "POST"
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No data")
//                    completion(false)
//                    return
//                }
//
//                guard let authorizationToken = try? JSONSerialization.jsonObject(with: data, options: []) as? String  else {
//                    completion(false)
//                    return
//                }
//
//                AuthorizationToken.saveToken(authorizationToken, lastDate: Date(timeIntervalSinceNow: 0))
//                completion(true)
//            }
//        }
//
//        task.resume()
    }
}


