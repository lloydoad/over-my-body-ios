//
//  HomeViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notesTabBarItem: UITabBarItem!
    @IBOutlet weak var previewNotesTableView: UITableView!
    
    private var notes: [NoteViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewNotesTableView.delegate = self
        previewNotesTableView.dataSource = self
        
        var data: [Note] = []
        data.append(Note(subject: "Create New Note", body: "", recipients: []))
        data.append(contentsOf: dummyData)
        notes = data.enumerated().map {
            NoteViewModel(
                subject: $0.element.subject,
                body: $0.element.body,
                recipients: $0.element.recipients,
                isTemplate: $0.offset == 0,
                index: $0.offset
            )
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteViewControllerIdentifier") as? NoteViewController else {
            return
        }
        
        guard indexPath.row < self.notes.count else {
            return
        }
        
        viewController.noteModel = notes[indexPath.row]
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = previewNotesTableView.dequeueReusableCell(withIdentifier: NotePreviewTableViewCell.identifier, for: indexPath) as? NotePreviewTableViewCell else {
            return UITableViewCell()
        }
        
        let note = notes[indexPath.row]
        cell.model = note
        return cell
    }
    
    @IBAction func unwindFromSave(segue: UIStoryboardSegue) {

        guard let viewController = segue.source as? NoteViewController, var newData = viewController.noteModel else {
            return
        }
        
        if newData.index == 0 {
            newData.index = self.notes.count
            newData.body = viewController.noteContentTextView.text
            self.notes.append(newData)
        } else if newData.index < self.notes.count {
            newData.body = viewController.noteContentTextView.text
            self.notes[newData.index] = newData
        }
        
        print("change")
        self.previewNotesTableView.reloadData()
    }
}
