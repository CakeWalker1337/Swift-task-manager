//
//  TaskCardViewCell.swift
//  TaskManager
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// Task collection view cell looks like a card with three labels describe the task: title, description and date label.
class TaskCardViewCell: UICollectionViewCell {

    @IBOutlet private weak var cardView: CardView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    var cardBackgroundColor: UIColor? {
        didSet {
            cardView.backgroundColor = cardBackgroundColor
        }
    }

    /// Delegate for catching click on "more" button
    var onMoreTap: (() -> Void)?

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

    @IBAction private func moreButtonDidClick(_ sender: Any) {
        onMoreTap?()
    }

}
