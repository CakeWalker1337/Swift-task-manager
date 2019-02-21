//
//  CreateTaskAlertView.swift
//  TaskManager
//
//  Created by User on 14/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// The class for customizing alertview
class CreateTaskAlertViewController: UIViewController {

    ///View element outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var mView: UIView!
    
    /// Delegate object of createTaskAlertView
    weak var delegate: CreateTaskAlertViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        nameTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    /// Sets view border and color style
    func setupView() {
        view.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    /// Animation of alertview appearing
    func animateView() {
        view.alpha = 0;
        self.view.frame.origin.y = self.view.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.alpha = 1.0;
            self.view.frame.origin.y = self.view.frame.origin.y - 50
        })
    }
    
    /// CancelButton click event callback
    @IBAction func cancelButtonDidClick(_ sender: Any) {
        nameTextField.resignFirstResponder()
        delegate?.createTaskAlertViewControllerDidClickCancel(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    /// CreateButton click event callback
    @IBAction func createButtonDidClick(_ sender: Any) {
        nameTextField.resignFirstResponder()
        delegate?.createTaskAlertViewControllerDidClickCreateTask(self, didCreate: Task(name: nameTextField.text!, desc: descriptionTextField.text!, dueDate: dueDatePicker.date))
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension CreateTaskAlertViewController: UITextFieldDelegate {
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
protocol CreateTaskAlertViewControllerDelegate: class {
    /// Callback-method for "cancel button clicked" event.
    func createTaskAlertViewControllerDidClickCancel(_ controller: CreateTaskAlertViewController)
    
    /// Callback-method for "create button clicked" event.
    /// - Parameter task: Task object created within data from alertdialog fields.
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: CreateTaskAlertViewController, didCreate task: Task)
    
}
