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
    
    public static let identifier: String = "NoteViewControllerIdentifier"
    
    let recipientButtonTemplate: String = " Recipients: Add More"
    
    var homeViewController: HomeViewController!
    var viewModel: NoteViewModel!
    var viewModelIndex: Int?
    
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
        guard !viewModel.isTemplate else {
            return
        }
        
        self.noteContentTextView.text = viewModel.body
        self.noteTitleTextField.text = viewModel.subject
        self.updateRecipientButtonText()
    }
    
    internal func updateRecipientButtonText() {
        self.addMoreRecipientsButton.setTitle("\(viewModel.recipients.count)\(recipientButtonTemplate)", for: .normal)
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
        if let subject = noteTitleTextField.text {
            self.viewModel.subject = subject
        }
    }
    
    @IBAction func addNewContactTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ContactsViewController.identifier) as? ContactsViewController else {
            return
        }
        
        viewController.viewModel = viewModel
        viewController.noteViewController = self
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.viewModel.body = self.noteContentTextView.text
        self.viewModel.isTemplate = false
        
        if let index = self.viewModelIndex {
            self.updateNote(note: self.viewModel, with: index)
        } else {
            self.addNewNote(note: self.viewModel)
        }
    }
    
    private func updateNote(note: NoteViewModel, with index: Int) {
        RequestSingleton.saveNote(note: note) { (model) in
            guard let noteViewModel = model else {
                return
            }
            
            guard self.homeViewController != nil else {
                return
            }
            
            self.homeViewController.viewModels[index] = noteViewModel
            self.homeViewController.previewNotesTableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func addNewNote(note: NoteViewModel) {
        RequestSingleton.createNote(note: note) { (model) in
            guard let noteViewModel = model else {
                return
            }
            
            guard self.homeViewController != nil else {
                return
            }
            
            self.homeViewController.viewModels.append(noteViewModel)
            self.homeViewController.previewNotesTableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
