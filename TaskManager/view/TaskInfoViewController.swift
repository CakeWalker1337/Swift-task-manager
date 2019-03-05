//
//  CreateTaskAlertView.swift
//  TaskManager
//
//  Created by User on 14/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// The class for customizing alertview


class TaskInfoViewController: UIViewController {

    enum WorkMode {
        case createTask, editTask
    }
    
    ///View element outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    var task: Task? = nil
    private var rowPath: IndexPath?
    var workMode = WorkMode.createTask
    
    /// Delegate object of createTaskAlertView
    weak var delegate: TaskInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        nameTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        if task != nil {
            nameTextField.text = task!.title
            descriptionTextField.text = task!.desc
            dueDatePicker.date = task!.dueDate
        }
    }
    
    /// Init function for workmode "Edit"
    func setInitData(rowPath: IndexPath, task: Task){
        self.rowPath = rowPath
        self.task = task
        workMode = WorkMode.editTask
    }
    
    /// CancelButton click event callback
    @IBAction func cancelButtonDidClick(_ sender: Any) {
        nameTextField.resignFirstResponder()
    }
    
    /// CreateButton click event callback
    @IBAction func createButtonDidClick(_ sender: Any) {
        nameTextField.resignFirstResponder()
        var resultTask: Task
        switch workMode {
        case .createTask:
            resultTask = Task(id: nil, title: nameTextField.text ?? "", desc: descriptionTextField.text ?? "", dueDate: dueDatePicker.date)
        case .editTask:
            task?.title = nameTextField.text ?? ""
            task?.desc = descriptionTextField.text ?? ""
            task?.dueDate = dueDatePicker.date
            resultTask = task!
        }
        delegate!.createTaskAlertViewControllerDidClickCreateTask(self, task: resultTask, rowPath: rowPath)
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension TaskInfoViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTextField {
            descriptionTextField.becomeFirstResponder()
        }
        return true
    }
}

/// The protocol of the AlertDialog view element.
/// Provides callback-methods for registering clicks from the AlertDialog
protocol TaskInfoViewControllerDelegate: class {
    
    /// Callback-method for "create button clicked" event.
    /// - Parameter task: Task object created within data from alertdialog fields.
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: TaskInfoViewController, task: Task, rowPath: IndexPath?)
    
}
