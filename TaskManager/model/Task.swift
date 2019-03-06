import Foundation
import UIKit.UIColor
import CoreData.NSManagedObjectID

///Task class described a task element: it's id in Core Data base, name, description and due date.
struct Task {

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
}
