//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var dateLabel: UILabel!
    
    var task: Task?{
        didSet{
            dateLabel.text = "Due to \(task?.dueDate.description ?? "unknown")"
            descLabel.text = task?.desc
            titleLabel.text = task?.name
        }
    }
    
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel?.text = nil
        self.descLabel?.text = nil
        self.dateLabel?.text = nil
    }
}




