//
//  TaskRepository.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import CoreData

/// The delegate provides functions to the presentation layer.
/// Contains some functions for interaction with Core Data object and methods.
protocol DashboardRepositoryProtocol: class {

    /// Fetches all tasks from the DB
    ///
    /// - Returns: an array with fetched tasks (entities)
    func fetchTasks() -> [TaskEntity]

    /// Saves task to the DB
    ///
    /// - Parameter taskEntity: entity to save
    /// - Returns: saved entity
    func saveTask(taskEntity: TaskEntity) -> TaskEntity?

    /// Removes task from the DB
    ///
    /// - Parameter taskEntity: task entity for removing
    func deleteTask(taskEntity: TaskEntity)

    /// Creates a new task entity from the entity description
    ///
    /// - Returns: DB-managed object (entity)
    func createNewTaskEntity() -> TaskEntity

    /// Fetches existing task from DB by object ID
    ///
    /// - Parameter taskId: objectID of the task
    /// - Returns: Entity from DB by object ID
    func receiveExistingTaskEntity(taskId: NSManagedObjectID) -> TaskEntity
}

/// The class contains some methods for work with Core Data.
/// Relates to the dashboard feature.
class DashboardRepository {

    /// The context of UIApplication. Used for the interaction with Core Data.
    var context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

}
extension DashboardRepository: DashboardRepositoryProtocol {

    func fetchTasks() -> [TaskEntity] {
        do {
            let fetchedResults = try context.fetch(NSFetchRequest(entityName: "TaskEntity")) as [TaskEntity]
            return fetchedResults
        } catch {
            print("Failed saving")
            return []
        }
    }

    func createNewTaskEntity() -> TaskEntity {
        let taskEntityBase = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context)
        if let operatedTask = NSManagedObject(entity: taskEntityBase!, insertInto: context) as? TaskEntity {
            return operatedTask
        }
        fatalError("Unable to create new NSManagedObject with type TaskEntity")
    }

    func receiveExistingTaskEntity(taskId: NSManagedObjectID) -> TaskEntity {
        do {
            if let taskEntity = try context.existingObject(with: taskId) as? TaskEntity {
                return taskEntity
            }
            fatalError("Entity type cast error: type of received object is not convertable to TaskEntity")
        } catch {
            fatalError("Impossible to get existing task by id \(taskId)")
        }
    }

    func saveTask(taskEntity: TaskEntity) -> TaskEntity? {
        saveContext()
        return taskEntity
    }

    /// Saves the context of database. May throw fatal error in failure case.
    private func saveContext() {
        do {
            try context.save()
            print("Context has been successfully saved.")
        } catch {
            fatalError("Failed saving. \(error)")
        }
    }

    func deleteTask(taskEntity: TaskEntity) {
        self.context.delete(taskEntity)
        print("Successfully deleted.")
        saveContext()
    }

}
