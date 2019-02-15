//
//  CreateTaskAlertView.swift
//  TaskManager
//
//  Created by User on 14/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// The class for customizing alertview
class CreateTaskAlertView: UIViewController {

    ///View element outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var mView: UIView!
    
    /// Delegate object of createTaskAlertView
    var delegate: CreateTaskAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
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
    @IBAction func onClickCancelButton(_ sender: Any) {
        nameTextField.resignFirstResponder()
        delegate?.cancelButtonClicked()
        self.dismiss(animated: true, completion: nil)
    }
    
    /// CreateButton click event callback
    @IBAction func onClickCreateButton(_ sender: Any) {
        nameTextField.resignFirstResponder()
        delegate?.createButtonClicked(task: Task(name: nameTextField.text!, desc: descriptionTextField.text!, dueDate: dueDatePicker.date))
        self.dismiss(animated: true, completion: nil)
    }
    
}
