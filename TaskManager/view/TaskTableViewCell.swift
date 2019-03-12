//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// Task table view cell class. Contains 3 outlets for title, description and date labels.
class TaskTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    var dueDate: String! {
        didSet {
            dateLabel.text = dueDate
        }
    }

    var desc: String! {
        didSet {
            descLabel.text = desc
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel?.text = nil
        self.descLabel?.text = nil
        self.dateLabel?.text = nil
    }
}
