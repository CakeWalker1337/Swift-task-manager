import Foundation
import UIKit.UIColor
import CoreData.NSManagedObjectID

///Task class described a task element: it's id in Core Data base, name, description and due date.
struct Task: Equatable {

    var objectId: NSManagedObjectID?
    var title: String
    var desc: String
    var dueDate: Date

    public init(objectId: NSManagedObjectID?, title: String, desc: String, dueDate: Date) {
        self.objectId = objectId
        self.title = title
        self.desc = desc
        self.dueDate = dueDate
    }

    static func == (task1: Task, task2: Task) -> Bool {
        return
            task1.title == task2.title &&
            task1.desc == task2.desc &&
            task1.dueDate == task2.dueDate
    }
}
