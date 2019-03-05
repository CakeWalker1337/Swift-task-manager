//
//  TaskCardViewCell.swift
//  TaskManager
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class TaskCardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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


