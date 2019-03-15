//
//  NotificationTimeOptions.swift
//  TaskManager
//
//  Created by User on 13/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

/// Enum of notification mode
///
/// - forHourBeforeDate: option for creating the notification for an hour before chosen date.
/// - forDate: with this notification service creates the notification for concrete date.
enum NotificationTimeOptions {
    case forHourBeforeDate
    case forDate
}
