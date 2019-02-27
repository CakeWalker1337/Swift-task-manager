//
//  TaskCardViewCell.swift
//  TaskManager
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class TaskCardViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var task: Task?{
        didSet{
            var seconds = Int(task?.dueDate?.timeIntervalSince(Date()) ?? 0)
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
            descriptionLabel.text = task?.desc
            titleLabel.text = task?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel?.text = nil
        self.descriptionLabel?.text = nil
        self.dateLabel?.text = nil
    }
}
