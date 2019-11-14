//
//  NotePreviewTableViewCell.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/3/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import UIKit

class NotePreviewTableViewCell: UITableViewCell {
    
    internal static var identifier: String = "PreviewNoteIdentifier"
    
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var previewTitleLabel: UILabel!
    @IBOutlet weak var previewTimeLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    internal var model: NoteViewModel? = nil {
        didSet {
            guard let note = self.model else { return }
            previewTitleLabel.text = note.subject
            previewTimeLabel.text = "\(note.recipients.count)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customBackgroundView.layer.borderWidth = 1
        customBackgroundView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) { }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.customBackgroundView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1)
        } else {
            self.customBackgroundView.backgroundColor = .white
        }
    }
}
