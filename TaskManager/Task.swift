//
//  Task.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
open class Task: Codable{
    
    var name: String
    var desc: String
    var dueDate: Date
    
    public init(name: String, desc: String, dueDate: Date){
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
    }
    
    public func toString(){
        
    }
    
}
