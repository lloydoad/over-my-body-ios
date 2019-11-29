//
//  ContactsViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/12/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var addNewEmailButton: UIButton!
    @IBOutlet weak var contactsSearchBar: UISearchBar!
    
    public static let identifier: String = "ContactsViewController"
    
    var viewModel: NoteViewModel!
    weak var noteViewController: NoteViewController?
    
    var allEmails: [String] = []
    var displayedEmails: [String] = []
    var isEmailSelected: [String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
        self.updateRecipientsButton()
        self.setupTableView()
        self.fetchContacts()
        self.setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.contactsTableView.reloadData()
    }
    
    private func setupSearchBar() {
        contactsSearchBar.delegate = self
    }
    
    private func setupTableView() {
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
    }
    
    private func fetchContacts() {
        Contacts.getContacts { (emails) in
            DispatchQueue.main.async {
                var allEmails = emails
                self.viewModel.recipients.forEach({ (viewModelEmail) in
                    if !allEmails.contains(viewModelEmail) {
                        allEmails.append(viewModelEmail)
                    }
                    
                    self.isEmailSelected[viewModelEmail] = true
                })
                
                allEmails.sort()
                self.allEmails = allEmails
                self.displayedEmails = allEmails
                self.contactsTableView.reloadData()
            }
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
        return self.displayedEmails.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard row < self.displayedEmails.count else {
            return
        }
        
        let selectedEmail = self.displayedEmails[row]
        if isEmailSelected[selectedEmail] == nil {
            isEmailSelected[selectedEmail] = true
        } else {
            isEmailSelected[selectedEmail] = !(isEmailSelected[selectedEmail] ?? true)
        }
        
        self.contactsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell, indexPath.row < self.displayedEmails.count else {
            return UITableViewCell()
        }
        
        cell.email = self.displayedEmails[indexPath.row]
        let isSelected = self.isEmailSelected[self.displayedEmails[indexPath.row]] ?? false
        cell.shouldDisplaySelectedBackground = isSelected
        return cell
    }
    
    // MARK: - Search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.lowercased() else {
            return
        }
        
        if query.isEmpty {
            self.displayedEmails = self.allEmails
        } else {
            self.displayedEmails = self.allEmails.filter {
                $0.lowercased().contains(query)
            }
        }
        
        self.contactsTableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        var selectedEmails: [String] = []
        for (key,isSelected) in self.isEmailSelected {
            if isSelected {
                selectedEmails.append(key)
            }
        }
        
        self.viewModel.recipients = selectedEmails
        guard let noteViewController = self.noteViewController else {
            return
        }
        
        noteViewController.viewModel = self.viewModel
        noteViewController.updateRecipientButtonText()
        self.dismiss(animated: true, completion: nil)
    }
}
