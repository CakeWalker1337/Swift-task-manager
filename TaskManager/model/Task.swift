
import Foundation
import UIKit.UIColor
import CoreData.NSManagedObjectID

///Task class described a task element: it's name, description and due date.
struct Task {
    
    var id: NSManagedObjectID?
    var title: String
    var desc: String
    var dueDate: Date
    
    public init(id: NSManagedObjectID?, title: String, desc: String, dueDate: Date){
        self.id = id
        self.title = title
        self.desc = desc
        self.dueDate = dueDate
    }
}
