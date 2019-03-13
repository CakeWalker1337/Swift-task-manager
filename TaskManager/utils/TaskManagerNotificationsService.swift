//
//  TaskManagerNotificationsService.swift
//  TaskManager
//
//  Created by User on 12/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UserNotifications

protocol TaskManagerNotificationsServiceProtocol {

    /// Creates the notification request for task.
    ///
    /// - Parameters:
    ///   - task: task for creating the request
    ///   - timeOption: TimeOption value for choosing notification mode.
    func addTaskDateNotification(task: Task, timeOption: NotificationTimeOptions)

    /// Removes all notifications for this task.
    ///
    /// - Parameter task: task object for removing notifications.
    func removeNotificationsForTask(task: Task)
}

/// The class manages notifications for taskmanager application
class TaskManagerNotificationsService {

    let center = UNUserNotificationCenter.current()

}
extension TaskManagerNotificationsService: TaskManagerNotificationsServiceProtocol {

    func addTaskDateNotification(task: Task, timeOption: NotificationTimeOptions) {
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
                if settings.alertSetting == .enabled {
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: task.title, arguments: nil)
                    var identifier: String
                    var triggerTimeInterval: TimeInterval
                    switch timeOption {
                    case .forHourBeforeDate:
                        identifier = String(task.objectId.hashValue)+"_1"
                        triggerTimeInterval = task.dueDate.timeIntervalSinceNow - Double(DateHelper.SecondsInHour)
                        content.body = NSString.localizedUserNotificationString(forKey: "1 hour left", arguments: nil)
                    case .forDate:
                        identifier = String(task.objectId.hashValue)+"_2"
                        triggerTimeInterval = task.dueDate.timeIntervalSinceNow
                        content.body = NSString.localizedUserNotificationString(forKey: "Now", arguments: nil)

                    }
                    // Configure the trigger for a 7am wakeup.
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTimeInterval, repeats: false)

                    // Create the request object.
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content,
                                                        trigger: trigger)

                    self.center.add(request) { (error: Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                        }
                    }
                }
            }
        })

    }

    func removeNotificationsForTask(task: Task) {
        let taskIdHashString = String(task.objectId.hashValue)
        center.removePendingNotificationRequests(withIdentifiers: [taskIdHashString+"_1", taskIdHashString+"_2"])
    }

}
