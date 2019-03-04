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
    func fetchTasks() -> [TaskEntity]
    func saveTask(taskEntity: TaskEntity) -> TaskEntity?
    func deleteTask(taskEntity: TaskEntity)
    func getNewTaskEntity() -> TaskEntity
    func getExistingTaskEntity(taskId: NSManagedObjectID) -> TaskEntity
}

class DashboardRepository {
    
    var context: NSManagedObjectContext?
    
    public init(context: NSManagedObjectContext?){
        self.context = context
    }
    
    
}
extension DashboardRepository: DashboardRepositoryDelegate {
    
    func fetchTasks() -> [TaskEntity] {
        do {
            let fetchedResults = try context!.fetch(NSFetchRequest(entityName: "TaskEntity")) as [TaskEntity]
            return fetchedResults
        } catch {
            print("Failed saving")
            return []
        }
    }
    
    func getNewTaskEntity() -> TaskEntity {
        let taskEntityBase = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context!)
        let operatedTask = NSManagedObject(entity: taskEntityBase!, insertInto: context!) as! TaskEntity
        return operatedTask
    }
    
    func getExistingTaskEntity(taskId: NSManagedObjectID) -> TaskEntity{
        do {
            let taskEntity = try context!.existingObject(with: taskId) as! TaskEntity
            return taskEntity
        } catch {
            fatalError("Impossible to get existing task by id \(taskId)")
        }
    }
    
    func saveTask(taskEntity: TaskEntity) -> TaskEntity? {
        do {
            try context!.save()
            print("Successfully saved.")
            return taskEntity
        } catch {
            fatalError("Failed saving. \(error)")
        }
    }
    
    func deleteTask(taskEntity: TaskEntity) {
        self.context?.delete(taskEntity)
        print("Successfully deleted.")
    }
    
    private func setTaskValuesIntoManagedObject(task: TaskEntity, object: NSManagedObject) {
        object.setValue(task.title, forKey: "title")
        object.setValue(task.desc, forKey: "desc")
        object.setValue(task.dueDate, forKey: "dueDate")
    }
}
