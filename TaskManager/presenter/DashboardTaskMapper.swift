//
//  DashboardTaskMapper.swift
//  TaskManager
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor

class DashboardTaskMapper {
    
    static func mapTaskFromEntity(entity: TaskEntity) -> Task {
        return Task(title: entity.title ?? "", desc: entity.desc ?? "", dueDate: entity.dueDate ?? Date())
    }
}
