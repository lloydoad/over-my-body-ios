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
    
    public static func saveContact(email: String, completion: @escaping (Bool) -> ()) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (accessGranted, error) in
            if let err = error {
                print(err)
                completion(false)
                return
            }
            
            guard accessGranted else {
                print("Access Denied")
                completion(false)
                return
            }
            
            let newContact = CNMutableContact()
            newContact.emailAddresses = [CNLabeledValue<NSString>(label: email, value: email as NSString)]
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier:nil)
            
            do {
                try store.execute(saveRequest)
                completion(true)
            } catch let error {
                print(error)
                completion(false)
            }
            
            completion(true)
            return
        }
    }
}
