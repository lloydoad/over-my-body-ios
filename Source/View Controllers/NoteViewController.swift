//
//  NoteViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/6/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var addMoreRecipientsButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    
    let recipientButtonTemplate: String = " Recipients: Add More"
    var noteModel: NoteViewModel?
    var contactsToBeAdded: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
        self.updateRecipientsButton()
        self.noteContentTextView.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepopulateContent()
    }
    
    private func prepopulateContent() {
        guard var model = noteModel, !model.isTemplate else {
            return
        }
        
        model.recipients.append(contentsOf: contactsToBeAdded.filter { !model.recipients.contains($0) })
        self.noteTitleTextField.text = model.subject
        self.noteContentTextView.text = model.body
        self.addMoreRecipientsButton.setTitle("\(model.recipients.count)\(recipientButtonTemplate)", for: .normal)
        self.noteModel = model
    }
    
    private func updateRecipientsButton() {
        self.addMoreRecipientsButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addMoreRecipientsButton.layer.borderWidth = 0.5
        self.addMoreRecipientsButton.layer.cornerRadius = 6
        self.addMoreRecipientsButton.setTitleColor(.black, for: .highlighted)
    }
    
    private func updateTopBarView() {
        self.topBarView.layer.cornerRadius = 16
        self.topBarView.layer.borderWidth = 1.5
        self.topBarView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    @IBAction func titleTextDidChange(_ sender: Any) {
        self.noteModel?.subject = noteTitleTextField.text ?? ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var tempStorage: NoteViewModel = NoteViewModel(subject: "", body: "", recipients: [], isTemplate: false, index: 0)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tempStorage.subject = noteTitleTextField.text ?? ""
        self.tempStorage.body = noteContentTextView.text
    }
    
    @IBAction func unwindToNoteView(segue: UIStoryboardSegue) {
        guard segue.identifier  == "saveIdentifier", let viewController = segue.source as? ContactsViewController else {
            return
        }
        
        self.contactsToBeAdded = viewController.isContactSelected.filter { $0.value == true }.map { (key: ContactViewModel, value: Bool) in
            return key.email
        }
        
        self.noteModel?.isTemplate = false
        self.noteModel?.body = tempStorage.body
        self.noteModel?.subject = tempStorage.subject
        prepopulateContent()
    }
}
