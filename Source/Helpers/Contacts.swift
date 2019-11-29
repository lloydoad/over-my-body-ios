//
//  Contacts.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation
import Contacts

public class Contacts {
    public static func getContacts(completion: @escaping ([String]) -> ()) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (accessGranted, error) in
            if let err = error {
                print(err)
                completion([])
                return
            }
            
            guard accessGranted else {
                print("Access Denied")
                completion([])
                return
            }
            
            var emails: [String] = []
            let keys = [CNContactEmailAddressesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor] )
            try? store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let email = contact.emailAddresses.first?.value as String? {
                    emails.append(email)
                }
            })
            
            completion(emails)
        }
    }
}
