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
    func fetchTasks() -> [Task]
    func insertTask(task: Task) -> Task
    func updateTask(task: Task)
    func sortTasks(tasks: inout [Task])
    func deleteTask(task: Task)
    
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
    func fetchTasks() -> [Task] {
        var tasks = dashboardRepository!.fetchTasks().map({DashboardTaskMapper.mapTaskFromEntity(entity: $0)})
        sortTasks(tasks: &tasks)
        return tasks
    }
    
    func sortTasks(tasks: inout [Task]) {
        tasks.sort(by: {(task1: Task, task2: Task) -> Bool in
            let now = Date()
            //red task is a task which due date has gone
            let isTask1Red = task1.dueDate.compare(now) == .orderedAscending
            let isTask2Red = task2.dueDate.compare(now) == .orderedAscending
            // effective state checking
            if isTask1Red && isTask2Red {
                return task1.dueDate.compare(task2.dueDate) == .orderedDescending
            }
            else if !isTask1Red && !isTask2Red {
                return task1.dueDate.compare(task2.dueDate) == .orderedAscending
            }
            return !isTask1Red
        })
    }
    
    func insertTask(task: Task) -> Task {
        
        var taskEntity = dashboardRepository!.getNewTaskEntity()
        DashboardTaskMapper.mapTaskToEntity(task: task, entity: &taskEntity)
        if let entity = dashboardRepository!.saveTask(taskEntity: taskEntity) {
            return DashboardTaskMapper.mapTaskFromEntity(entity: entity)
        } else {
            fatalError("Insertion failed! Task with title \(task.title) couldn't be inserted.")
        }
    }
    
    func updateTask(task: Task) {
        var taskEntity = dashboardRepository!.getExistingTaskEntity(taskId: task.id!)
        DashboardTaskMapper.mapTaskToEntity(task: task, entity: &taskEntity)
        if dashboardRepository!.saveTask(taskEntity: taskEntity) == nil {
            fatalError("Update failure! Task with title \(task.title) couldn't be updated.")
        }
    }
    
    func deleteTask(task: Task) {
        let taskEntity = dashboardRepository!.getExistingTaskEntity(taskId: task.id!)
        dashboardRepository!.deleteTask(taskEntity: taskEntity)
    }
    
    func formatDueDateString(dueDate: Date) -> String {
        return DateHelper.formatDateToRemainingTimeStringFormat(date: dueDate)
    }
    
    func getCellColorByDueDate(dueDate: Date) -> UIColor{
        var backgroundCellColor: UIColor
        let seconds = Int(dueDate.timeIntervalSince(Date()))
        
        if abs(seconds) / DateHelper.SecondsInMinute > 0 {
            
            if seconds > DateHelper.SecondsInWeek {
                backgroundCellColor = UIColor(hue: ColorHelper.toHueFloat(deg: 130),
                                              saturation: 0.4,
                                              brightness: ColorHelper.maxColorArgValue,
                                              alpha: ColorHelper.maxColorArgValue)
            } else if seconds < 0 {
                backgroundCellColor = UIColor.gray
            } else {
                print("Ex \(ColorHelper.toHueFloat(deg: 130))")
                backgroundCellColor = UIColor(hue: (CGFloat(seconds) / CGFloat(DateHelper.SecondsInWeek)) * ColorHelper.toHueFloat(deg: 130),
                                              saturation: 0.4,
                                              brightness: ColorHelper.maxColorArgValue,
                                              alpha: ColorHelper.maxColorArgValue)
            }
        } else {
            backgroundCellColor = UIColor(hue: ColorHelper.minColorArgValue,
                                          saturation: 0.4,
                                          brightness: ColorHelper.maxColorArgValue,
                                          alpha: ColorHelper.maxColorArgValue)
        }
        return backgroundCellColor
    }
}

