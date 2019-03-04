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

final class DashboardTaskMapper {
    
    static func mapTaskFromEntity(entity: TaskEntity) -> Task {
        return Task(id: entity.objectID, title: entity.title ?? "", desc: entity.desc ?? "", dueDate: entity.dueDate ?? Date())
    }
        
    static func mapTaskToEntity(task: Task, entity: inout TaskEntity) {
        entity.title = task.title
        entity.desc = task.desc
        entity.dueDate = task.dueDate
    }
    
}
