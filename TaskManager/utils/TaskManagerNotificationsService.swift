//
//  TaskManagerNotificationsService.swift
//  TaskManager
//
//  Created by User on 12/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import CoreData.NSManagedObjectID
import Foundation
import UserNotifications

protocol TaskManagerNotificationsServiceProtocol {

    /// Creates the notification request for task.
    ///
    /// - Parameters:
    ///   - task: task for creating the request
    ///   - timeOption: TimeOption value for choosing notification mode.
    func scheduleTaskDateNotification(task: Task, timeOption: NotificationTimeOptions)

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

    func scheduleTaskDateNotification(task: Task, timeOption: NotificationTimeOptions) {
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
                if settings.alertSetting == .enabled {
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: task.title, arguments: nil)
                    var identifier: String
                    var triggerTimeInterval: TimeInterval
                    switch timeOption {
                    case .forHourBeforeDate:
                        triggerTimeInterval = task.dueDate.timeIntervalSinceNow - Double(DateHelper.SecondsInHour)
                        content.body = NSString.localizedUserNotificationString(forKey: "1 hour left", arguments: nil)
                    case .forDate:
                        triggerTimeInterval = task.dueDate.timeIntervalSinceNow
                        content.body = NSString.localizedUserNotificationString(forKey: "Now", arguments: nil)

                    }
                    identifier = self.notificationIdentifier(for: task.objectId!, timeOption: timeOption)
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

    private func notificationIdentifier(for identifier: NSManagedObjectID, timeOption: NotificationTimeOptions) -> String {
        let uid = identifier.uriRepresentation().absoluteString
        switch timeOption {
        case .forHourBeforeDate: return uid + "_1"
        case .forDate: return uid + "_2"
        }
    }

    func removeNotificationsForTask(task: Task) {
        let uid = task.objectId!.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [uid+"_1", uid+"_2"])
    }

}
