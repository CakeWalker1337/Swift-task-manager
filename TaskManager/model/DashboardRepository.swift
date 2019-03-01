//
//  TaskRepository.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import CoreData


protocol DashboardRepositoryDelegate {
    func fetchTasksFromDB() -> [TaskEntity]
}

class DashboardRepository {
    
    var context: NSManagedObjectContext?
    
    public init(context: NSManagedObjectContext?){
        self.context = context
    }
    
    
}
extension DashboardRepository: DashboardRepositoryDelegate {
    
    func fetchTasksFromDB() -> [TaskEntity] {
        do {
            var fetchedResults = try context!.fetch(NSFetchRequest(entityName:"Task")) as [TaskEntity]
            fetchedResults.sort(by: {(task1: TaskEntity, task2: TaskEntity) -> Bool in
                let now = Date()
                //red task is a task which due date has gone
                let isTask1Red = task1.dueDate!.compare(now) == .orderedAscending
                let isTask2Red = task2.dueDate!.compare(now) == .orderedAscending
                // effective state checking
                if isTask1Red && isTask2Red {
                    return task1.dueDate!.compare(task2.dueDate!) == .orderedDescending
                }
                else if !isTask1Red && !isTask2Red {
                    return task1.dueDate!.compare(task2.dueDate!) == .orderedAscending
                }
                return !isTask1Red
            })
            return fetchedResults
        } catch {
            print("Failed saving")
            return []
        }
    }
    
    func insertTask(task: TaskEntity) -> Bool {
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context!)
        let operatedTask = NSManagedObject(entity: taskEntity!, insertInto: context!)
        setTaskValuesIntoManagedObject(task: task, object: operatedTask)
        do {
            try context!.save()
            print("Successfully saved.")
            return true
        } catch {
            print("Failed saving. \(error)")
            return false
        }
    }
    
    func deleteTask(task: TaskEntity) {
        self.context?.delete(task)
        print("Successfully deleted.")
    }
    
    func updateTask(task: TaskEntity) -> Bool {
        setTaskValuesIntoManagedObject(task: task, object: task)
        do {
            try context!.save()
            print("Successfully saved.")
            return true
        } catch {
            print("Failed saving. \(error)")
            return false
        }
    }
    
    private func setTaskValuesIntoManagedObject(task: TaskEntity, object: NSManagedObject) {
        object.setValue(task.title, forKey: "title")
        object.setValue(task.desc, forKey: "desc")
        object.setValue(task.dueDate, forKey: "dueDate")
    }
}
