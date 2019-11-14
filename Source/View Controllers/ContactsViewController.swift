//
//  ContactsViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var addNewEmailButton: UIButton!
    @IBOutlet weak var contactsSearchBar: UISearchBar!
    
    var viewModel: [ContactViewModel] = []
    var displayedViewModel: [ContactViewModel] = []
    var isContactSelected: [ContactViewModel:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
        self.updateRecipientsButton()
        self.setupTableView()
        self.fetchContacts()
        self.setupSearchBar()
    }
    
    private func setupSearchBar() {
        contactsSearchBar.delegate = self
    }
    
    private func setupTableView() {
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
    }
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (accessGranted, error) in
            if let err = error {
                print(err)
                return
            }
            
            guard accessGranted else {
                print("Access Denied")
                return
            }
            
            var tempViewModel: [ContactViewModel] = []
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor] )
            try? store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let email = contact.emailAddresses.first?.value as String? {
                    tempViewModel.append(ContactViewModel(
                        firstName: contact.givenName,
                        lastName: contact.familyName,
                        email: email)
                    )
                }
            })
            
            self.viewModel = tempViewModel
            self.viewModel.sort()
            self.displayedViewModel = self.viewModel
            self.contactsTableView.reloadData()
        }
    }
    
    private func updateRecipientsButton() {
        self.addNewEmailButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addNewEmailButton.layer.borderWidth = 0.5
        self.addNewEmailButton.layer.cornerRadius = 8
        self.addNewEmailButton.setTitleColor(.black, for: .highlighted)
    }
    
    private func updateTopBarView() {
        self.topBarView.layer.cornerRadius = 16
        self.topBarView.layer.borderWidth = 1.5
        self.topBarView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedViewModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard row < self.displayedViewModel.count else {
            return
        }
        
        let selectedContact = self.displayedViewModel[row]
        if isContactSelected[selectedContact] == nil {
            isContactSelected[selectedContact] = true
        } else {
            isContactSelected[selectedContact] = !(isContactSelected[selectedContact] ?? true)
        }
        
        self.contactsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell, indexPath.row < self.viewModel.count else {
            return UITableViewCell()
        }
        
        cell.viewModel = self.displayedViewModel[indexPath.row]
        let isSelected = self.isContactSelected[self.displayedViewModel[indexPath.row]] ?? false
        cell.shouldDisplaySelectedBackground = isSelected
        return cell
    }
    
    // MARK: - Search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.lowercased() else {
            return
        }
        
        if query.isEmpty {
            self.displayedViewModel = self.viewModel
        } else {
            self.displayedViewModel = self.viewModel.filter {
                $0.firstName.lowercased().contains(query) ||
                $0.lastName.lowercased().contains(query) ||
                $0.email.lowercased().contains(query)
            }
        }
        
        self.contactsTableView.reloadData()
    }
    
    @IBAction func unwindToContactsViewController(segue: UIStoryboardSegue) {
        guard segue.identifier  == "saveIdentifier", let viewController = segue.source as? NewContactViewController else {
            return
        }
        
        let newContactData = viewController.contact
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (accessGranted, error) in
            if let err = error {
                print(err)
                return
            }

            guard accessGranted else {
                print("Access Denied")
                return
            }
            
            var tempViewModel: [ContactViewModel] = []
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor] )
            try? store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let email = contact.emailAddresses.first?.value as String? {
                    tempViewModel.append(ContactViewModel(
                        firstName: contact.givenName,
                        lastName: contact.familyName,
                        email: email)
                    )
                }
            })
            
            let newContact = CNMutableContact()
            newContact.givenName = newContactData.firstName
            newContact.familyName = newContactData.lastName
            newContact.emailAddresses = [CNLabeledValue<NSString>(label: newContactData.email, value: newContactData.email as NSString)]
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier:nil)
            
            do {
                try store.execute(saveRequest)
                tempViewModel.append(newContactData)
                
                self.viewModel = tempViewModel
                self.viewModel.sort()
                self.displayedViewModel = self.viewModel
                self.contactsTableView.reloadData()
            } catch let error {
                print(error)
            }
            
            return
        }
    }
}
