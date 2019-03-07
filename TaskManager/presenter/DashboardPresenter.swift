//
//  TasksPresenter.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor
import CoreData

/// The protocol to provide some operable busines-logic methods to the view layer.
protocol DashboardPresenterDelegate: class {

    /// Fetches all tasks from the DB
    ///
    /// - Returns: an array with fetched tasks (presentation objects)
    func fetchTasks() -> [Task]

    /// Saves task to the DB
    ///
    /// - Parameter task: task object to save
    /// - Returns: saved object
    func insertTask(task: Task) -> Task

    /// Saves task to the DB
    ///
    /// - Parameter task: task object to save
    func updateTask(task: Task)

    /// Sorts task list by custom format: tasks which need to be done - first
    /// (ascending), tasks which have done overpast - last (ascending by recent)
    ///
    /// - Parameter tasks: an array of tasks to sort (inout)
    func sortTasks(tasks: inout [Task])

    /// Removes task from the DB
    ///
    /// - Parameter task: task for removing
    func deleteTask(task: Task)

    /// Calculates the color of the cell by it's due date.
    ///
    /// - Parameter dueDate: date to calculate the color
    /// - Returns: cell color object
    func calculateCellColorByDueDate(dueDate: Date) -> UIColor

    /// Formats date to the "1d 1h 1m left/ago" format
    ///
    /// - Parameter dueDate: date object to format
    /// - Returns: formatted date as string value
    func formatDueDateString(dueDate: Date) -> String

    func provideManagedObjectContext(context: NSManagedObjectContext)
}

/// The class contains some business-logic methods like sorting, formatting,
/// providing model objects to the repository layer, etc
class DashboardPresenter {
    var dashboardView: DashboardViewControllerDelegate?
    var context: NSManagedObjectContext?
    lazy var dashboardRepository: DashboardRepositoryDelegate? = {
        if context != nil {
            return DashboardRepository(context: context!)
        }
        fatalError("Attempt to initialize repository object with unprovided context.")
    }()

    public init(dashboardDelegate: DashboardViewControllerDelegate?) {
        self.dashboardView = dashboardDelegate
    }

}

extension DashboardPresenter: DashboardPresenterDelegate {
    func provideManagedObjectContext(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTasks() -> [Task] {
        var tasks = dashboardRepository!.fetchTasks().map({ DashboardTaskMapper.mapTaskFromEntity(entity: $0) })
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
            } else if !isTask1Red && !isTask2Red {
                return task1.dueDate.compare(task2.dueDate) == .orderedAscending
            }
            return !isTask1Red
        })
    }

    func insertTask(task: Task) -> Task {

        var taskEntity = dashboardRepository!.createNewTaskEntity()
        DashboardTaskMapper.mapTaskToEntity(task: task, entity: &taskEntity)
        if let savedTask = dashboardRepository!.saveTask(taskEntity: taskEntity) {
            return DashboardTaskMapper.mapTaskFromEntity(entity: savedTask)
        } else {
            fatalError("Insertion failed! Task with title \(task.title) couldn't be inserted.")
        }
    }

    func updateTask(task: Task) {
        var taskEntity = dashboardRepository!.receiveExistingTaskEntity(taskId: task.objectId!)
        DashboardTaskMapper.mapTaskToEntity(task: task, entity: &taskEntity)
        if dashboardRepository!.saveTask(taskEntity: taskEntity) == nil {
            fatalError("Update failure! Task with title \(task.title) couldn't be updated.")
        }
    }

    func deleteTask(task: Task) {
        let taskEntity = dashboardRepository!.receiveExistingTaskEntity(taskId: task.objectId!)
        dashboardRepository!.deleteTask(taskEntity: taskEntity)
    }

    func formatDueDateString(dueDate: Date) -> String {
        return DateHelper.formatDateToRemainingTimeStringFormat(date: dueDate)
    }

    func calculateCellColorByDueDate(dueDate: Date) -> UIColor {
        return ColorHelper.calculateCellColorByDueDate(dueDate: dueDate)
    }
}
