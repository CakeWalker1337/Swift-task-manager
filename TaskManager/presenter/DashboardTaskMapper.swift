//
//  DashboardTaskMapper.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor
import CoreData

/// The mapper from presentation to repository layers and vice versa.
final class DashboardTaskMapper {

    /// Maps task entity to task presentation object
    ///
    /// - Parameter entity: task entity object
    /// - Returns: task presentation object
    static func mapTaskFromEntity(entity: TaskEntity) -> Task {
        return Task(objectId: entity.objectID, title: entity.title ?? "", desc: entity.desc ?? "", dueDate: entity.dueDate ?? Date())
    }

    /// Maps task presentation object to the task entity
    ///
    /// - Parameters:
    ///   - task: task presentation object for mapping
    ///   - entity: inout entity object to store data.
    /// (inout because impossible to create a new entity object on this layer)
    static func mapTaskToEntity(task: Task, entity: inout TaskEntity) {
        entity.title = task.title
        entity.desc = task.desc
        entity.dueDate = task.dueDate
    }

}
