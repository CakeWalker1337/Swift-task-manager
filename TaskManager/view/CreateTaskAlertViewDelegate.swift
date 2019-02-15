//
//  CreateTaskAlertViewDelegate.swift
//  TaskManager
//
//  Created by User on 14/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// The protocol of the AlertDialog view element.
/// Provides callback-methods for registering clicks from the AlertDialog
protocol CreateTaskAlertViewDelegate: class {
    /// Callback-method for "cancel button clicked" event.
    func cancelButtonClicked()
    
    /// Callback-method for "create button clicked" event.
    /// - Parameter task: Task object created within data from alertdialog fields.
    func createButtonClicked(task: Task)
    
}
