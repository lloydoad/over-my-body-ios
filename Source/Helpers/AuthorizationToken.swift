//
//  AuthorizationToken.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/30/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public class AuthorizationToken {
    
    private static var bearer: String? = nil
    private static var lastFetchDate: Date? = nil
    
    private static var username: String? = nil
    private static var password: String? = nil
    
    private static let authorizationKey: String = "AuthorizationKey"
    private static let lastFetchDateKey: String = "LastFetchDateKey"
    
    private static let usernameKey: String = "UsernameKey"
    private static let passwordKey: String = "PasswordKey"
    
    public static func saveToken(_ value: String, lastDate: Date, username: String, password: String) {
        let defaults = UserDefaults.standard
        self.bearer = value
        self.lastFetchDate = lastDate
        self.username = username
        self.password = password
        
        defaults.set(value, forKey: authorizationKey)
        defaults.set(lastDate, forKey: lastFetchDateKey)
        defaults.set(username, forKey: usernameKey)
        defaults.set(password, forKey: passwordKey)
    }
    
    public static func getUserDefaultsToken() -> (String?, Date?, String?, String?) {
        let defaults = UserDefaults.standard
        return (
            defaults.string(forKey: authorizationKey),
            defaults.object(forKey: lastFetchDateKey) as? Date,
            defaults.string(forKey: usernameKey),
            defaults.string(forKey: passwordKey)
        )
    }
    
    public static func establishAuthorization() {
        let userData = getUserDefaultsToken()
        if let token = userData.0, let lastDate = userData.1, let username = userData.2, let password = userData.3 {
            saveToken(token, lastDate: lastDate, username: username, password: password)
        }
    }
    
    public static func getAppToken() -> (String?, Date?, String?, String?) {
        return (bearer, lastFetchDate, username, password)
    }
    
    public static func clearAppToken() {
        let defaults = UserDefaults.standard
        bearer = nil
        lastFetchDate = nil
        username = nil
        password = nil
        
        defaults.removeObject(forKey: authorizationKey)
        defaults.removeObject(forKey: lastFetchDateKey)
        defaults.removeObject(forKey: usernameKey)
        defaults.removeObject(forKey: passwordKey)
    }
}
