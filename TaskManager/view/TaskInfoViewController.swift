//
//  CreateTaskAlertView.swift
//  TaskManager
//
//  Created by User on 14/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

///The view controller of the view displays task data
class TaskInfoViewController: UIViewController {

    /// The controller's work mode
    ///
    /// - createTask: creating task mode (task data is not required)
    /// - editTask: editing task mode (task data is required)
    enum WorkMode {
        case createTask, editTask
    }

    @IBOutlet private weak var navItem: UINavigationItem!
    ///View element outlets
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    var task: Task?
    private var rowPath: IndexPath?
    var workMode = WorkMode.createTask

    weak var delegate: TaskInfoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.minimumDate = Date()
        titleTextField.becomeFirstResponder()
        titleTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        if task != nil {
            titleTextField.text = task!.title
            descriptionTextField.text = task!.desc
            dueDatePicker.date = task!.dueDate
        }
    }

    /// Init function for workmode "Edit"
    ///
    /// - Parameters:
    ///   - rowPath: rowPath to the element in containter
    ///   - task: object with data for editing
    func setInitData(rowPath: IndexPath, task: Task) {
        self.rowPath = rowPath
        self.task = task
        self.navItem.title = "Edit task"
        workMode = WorkMode.editTask
    }

    /// CancelButton click event callback
    @IBAction private func cancelButtonDidClick(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }

    /// CreateButton click event callback
    @IBAction private func createButtonDidClick(_ sender: Any) {
        titleTextField.resignFirstResponder()
        if checkDataValidation() {
            var resultTask: Task
            switch workMode {
            case .createTask:
                resultTask = Task(objectId: nil,
                                  title: titleTextField.text ?? "",
                                  desc: descriptionTextField.text ?? "",
                                  dueDate: dueDatePicker.date)
            case .editTask:
                task?.title = titleTextField.text ?? ""
                task?.desc = descriptionTextField.text ?? ""
                task?.dueDate = dueDatePicker.date
                resultTask = task!
            }
            delegate!.taskInfoViewController(self, didUpdate: resultTask, at: rowPath)

            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func checkDataValidation() -> Bool {
        var result = true
        if titleTextField.text == nil || (titleTextField.text?.isEmpty)! {
            print("yes")
            setTextFieldBackgroundColor(textField: titleTextField, isValid: false)
            result = false
        } else {
            setTextFieldBackgroundColor(textField: titleTextField, isValid: true)
        }
        if descriptionTextField.text == nil || (descriptionTextField.text?.isEmpty)! {
            setTextFieldBackgroundColor(textField: descriptionTextField, isValid: false)
            result = false
        } else {
            setTextFieldBackgroundColor(textField: descriptionTextField, isValid: true)
        }
        return result
    }

    func setTextFieldBackgroundColor(textField: UITextField, isValid: Bool) {
        if !isValid {
            textField.backgroundColor = UIColor(hue: ColorHelper.minColorArgValue,
                                                           saturation: 0.7,
                                                           brightness: ColorHelper.maxColorArgValue,
                                                           alpha: ColorHelper.maxColorArgValue)
        } else {
            textField.backgroundColor = UIColor.white
        }
    }

}
extension TaskInfoViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        }
        return true
    }
}

/// The protocol of the AlertDialog view element.
/// Provides callback-methods for registering clicks from the AlertDialog
protocol TaskInfoViewControllerDelegate: class {

    /// Callback-method calls when this controller updates (creates) task.
    /// - Parameter task: Task object created within data from alertdialog fields.
    func taskInfoViewController(_ controller: TaskInfoViewController, didUpdate task: Task, at rowPath: IndexPath?)

}
