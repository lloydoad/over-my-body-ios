//
//  HomeViewController.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 10/28/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notesTabBarItem: UITabBarItem!
    @IBOutlet weak var previewNotesTableView: UITableView!
    
    public var viewModels: [NoteViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewNotesTableView.delegate = self
        self.previewNotesTableView.dataSource = self
        
        var templateNote = NoteViewModel(model: NoteModel(
            _id: "",
            subject: "Create new note",
            recipients: [],
            body: ""
        ))
        templateNote.isTemplate = true
        
        self.viewModels.insert(templateNote, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.previewNotesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModels.count else {
            return
        }
        
        if editingStyle == .delete {
            removeNote(self.viewModels[indexPath.row], at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NoteViewController.identifier) as? NoteViewController else {
            return
        }
        
        guard indexPath.row < self.viewModels.count else {
            return
        }
        
        let model = self.viewModels[indexPath.row]
        
        viewController.viewModelIndex = model.isTemplate ? nil : indexPath.row
        viewController.homeViewController = self
        viewController.viewModel = model
        
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = previewNotesTableView.dequeueReusableCell(withIdentifier: NotePreviewTableViewCell.identifier, for: indexPath) as? NotePreviewTableViewCell else {
            return UITableViewCell()
        }
        
        let note = self.viewModels[indexPath.row]
        cell.model = note
        return cell
    }
    
    private func removeNote(_ note: NoteViewModel, at indexPath: IndexPath) {
        SVProgressHUD.show()
        RequestSingleton.deleteNote(note: note) { (didSucceed) in
            DispatchQueue.main.async {
                guard didSucceed else {
                    SVProgressHUD.dismiss()
                    return
                }
                
                SVProgressHUD.dismiss()
                self.viewModels.remove(at: indexPath.row)
                self.previewNotesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
