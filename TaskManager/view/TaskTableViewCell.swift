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
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var task: Task?{
        didSet{
            var seconds = Int(task?.dueDate.timeIntervalSince(Date()) ?? 0)
            if abs(seconds) / DateHelper.SecondsInMinute > 0 {
                var postScript: String = ""
                var resultString: String = ""
                if seconds > 0 {
                    postScript.append("left")
                } else {
                    postScript.append("ago")
                }
                seconds = abs(seconds)
                if seconds / DateHelper.SecondsInYear > 0 {
                    resultString.append("\(seconds / DateHelper.SecondsInYear)Y ")
                    seconds %= DateHelper.SecondsInYear
                }
                if seconds / DateHelper.SecondsInMonth > 0 {
                    resultString.append("\(seconds / DateHelper.SecondsInMonth)M ")
                    seconds %= DateHelper.SecondsInMonth
                }
                if seconds / DateHelper.SecondsInDay > 0 {
                    resultString.append("\(seconds / DateHelper.SecondsInDay)d ")
                    seconds %= DateHelper.SecondsInDay
                }
                if seconds / DateHelper.SecondsInHour > 0 {
                    resultString.append("\(seconds / DateHelper.SecondsInHour)h ")
                    seconds %= DateHelper.SecondsInHour
                }
                if seconds / DateHelper.SecondsInMinute > 0 {
                    resultString.append("\(seconds / DateHelper.SecondsInMinute)m ")
                    seconds %= DateHelper.SecondsInMinute
                }
                dateLabel.text = resultString + postScript
            } else {
                dateLabel.text = "now"
            }
            descLabel.text = task?.desc
            titleLabel.text = task?.name
        }
    }
    
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




