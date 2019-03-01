
import Foundation
import UIKit.UIColor

///Task class described a task element: it's name, description and due date.
struct Task {
    
    var title: String
    var desc: String
    var dueDate: Date
    
    public init(title: String, desc: String, dueDate: Date){
        self.title = title
        self.desc = desc
        self.dueDate = dueDate
    }
}
