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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTopBarView()
        self.updateRecipientsButton()
        self.noteContentTextView.text = ""
        self.prepopulateContent()
    }
    
    private func prepopulateContent() {
        guard let model = noteModel, !model.isTemplate else {
            return
        }
        
        self.noteTitleTextField.text = model.subject
        self.noteContentTextView.text = model.body
        self.addMoreRecipientsButton.setTitle("\(model.recipients.count)\(recipientButtonTemplate)", for: .normal)
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
    
    @IBAction func unwindToNoteView(segue: UIStoryboardSegue) {
        
    }
}
