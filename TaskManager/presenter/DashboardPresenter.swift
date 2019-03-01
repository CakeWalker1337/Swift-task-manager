//
//  TasksPresenter.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor

protocol DashboardPresenterDelegate {
    func fetchTasksFromDB() -> [Task]
    
    func getCellColorByDueDate(dueDate: Date) -> UIColor
    
    func formatDueDateString(dueDate: Date) -> String
}

class DashboardPresenter {
    var dashboardView: DashboardViewControllerDelegate?
    var dashboardRepository: DashboardRepositoryDelegate?
    
    public init(dashboardDelegate: DashboardViewControllerDelegate)
    {
        self.dashboardView = dashboardDelegate
        dashboardRepository = DashboardRepository(context: self.dashboardView!.getManagedObjectContext())
    }
}

extension DashboardPresenter: DashboardPresenterDelegate {
    func fetchTasksFromDB() -> [Task] {
        let tasks = dashboardRepository!.fetchTasksFromDB().map({DashboardTaskMapper.mapTaskFromEntity(entity: $0)})
        return tasks
    }
    
    func formatDueDateString(dueDate: Date) -> String {
        
        var seconds = Int(dueDate.timeIntervalSince(Date()))
        if abs(seconds) / DateHelper.SecondsInMinute > 0 {
            var resultDateString: String = ""
            var postScript: String = ""
            
            if seconds > 0 {
                postScript.append("left")
            } else {
                postScript.append("ago")
            }
            
            seconds = abs(seconds)
            
            if seconds / DateHelper.SecondsInYear > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInYear)Y ")
                seconds %= DateHelper.SecondsInYear
            }
            if seconds / DateHelper.SecondsInMonth > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInMonth)M ")
                seconds %= DateHelper.SecondsInMonth
            }
            if seconds / DateHelper.SecondsInDay > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInDay)d ")
                seconds %= DateHelper.SecondsInDay
            }
            if seconds / DateHelper.SecondsInHour > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInHour)h ")
                seconds %= DateHelper.SecondsInHour
            }
            if seconds / DateHelper.SecondsInMinute > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInMinute)m ")
                seconds %= DateHelper.SecondsInMinute
            }
            return resultDateString + postScript
        } else {
            return "now"
        }
    }
    
    func getCellColorByDueDate(dueDate: Date) -> UIColor{
        var backgroundCellColor: UIColor
        let seconds = Int(dueDate.timeIntervalSince(Date()))
        
        if abs(seconds) / DateHelper.SecondsInMinute > 0 {
            
            if seconds > DateHelper.SecondsInWeek {
                backgroundCellColor = UIColor(hue: 130.0/365.0, saturation: 0.4, brightness: 1.0, alpha: 1.0)
            } else if seconds < 0 {
                backgroundCellColor = UIColor.gray
            } else {
                backgroundCellColor = UIColor(hue: CGFloat( Double(seconds) * (130.0/365.0) / Double(DateHelper.SecondsInWeek)),
                                              saturation: 0.4,
                                              brightness: 1.0,
                                              alpha: 1.0)
            }
        } else {
            backgroundCellColor = UIColor(hue: 0, saturation: 0.4, brightness: 1.0, alpha: 1.0)
        }
        return backgroundCellColor
    }
}

