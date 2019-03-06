//
//  ViewController.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit
import Foundation
import CoreData

/// Delegate connects this one view to the presenter
protocol DashboardViewControllerDelegate {
    func getManagedObjectContext() -> NSManagedObjectContext
}

/// The main view controller manages two main data containers
class DashboardViewController: UIViewController {
    
    var dashboardPresenter: DashboardPresenterDelegate?
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    @IBOutlet weak var dashboardTableView: UITableView!
    private var data: [Task] = []
    
    let taskTableCellIdentifier = "TaskTableViewCell"
    private let taskCollectionCellIdentifier = "TaskCardViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardPresenter = DashboardPresenter(dashboardDelegate: self)
        data = dashboardPresenter!.fetchTasks()
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self
        dashboardCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardCollectionView.isHidden = true
        dashboardTableView.isHidden = true
        let designOption = Configuration.shared.dashboardDesignOption
        switch designOption {
        case .table:
            dashboardTableView.isHidden = false
        case .cards:
            dashboardCollectionView.isHidden = false
        default:
            //this one can be useful for adding a new option
            print("Unexpected design option!")
        }
        
    }
    
    @IBAction private func createTaskButtonDidClick(_ sender: Any) {
        let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskInfoViewController") as! TaskInfoViewController
        taskViewController.delegate = self
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    
    /// The function for updating data inside containers
    func updateTaskContainers(){
        dashboardTableView.reloadData()
        dashboardCollectionView.reloadData()
    }
    
    func requestTaskRemoval(indexPath: IndexPath) {
        self.dashboardPresenter!.deleteTask(task: self.data[indexPath.row])
        self.data.remove(at: indexPath.row)
        self.dashboardTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        self.dashboardCollectionView.deleteItems(at: [indexPath])
    }
    
    func requestTaskEditing(indexPath: IndexPath) {
        let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskInfoViewController") as! TaskInfoViewController
        taskViewController.delegate = self
        taskViewController.setInitData(rowPath: indexPath, task: self.data[indexPath.row])
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
}
extension DashboardViewController: DashboardViewControllerDelegate {
    func getManagedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension DashboardViewController: TaskInfoViewControllerDelegate{
    
    func taskInfoViewController(_ controller: TaskInfoViewController, didUpdate task: Task, at rowPath: IndexPath?) {
        if controller.workMode == TaskInfoViewController.WorkMode.createTask {
            let newTask = dashboardPresenter!.insertTask(task: task)
            data.append(newTask)
            
        }
        else if controller.workMode == TaskInfoViewController.WorkMode.editTask {
            self.data[rowPath!.row] = task
            self.dashboardPresenter!.updateTask(task: task)
        }
        self.dashboardPresenter?.sortTasks(tasks: &data)
        self.updateTaskContainers()
    }
}
extension DashboardViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellIdentifier, for: indexPath) as! TaskTableViewCell
        let task = data[indexPath.row]
        cell.title = task.title
        cell.desc = task.desc
        cell.dueDate = dashboardPresenter?.formatDueDateString(dueDate: task.dueDate)
        cell.backgroundColor = dashboardPresenter?.getCellColorByDueDate(dueDate: task.dueDate)
        return cell
    }
    
}
extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        return UISwipeActionsConfiguration()
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.requestTaskEditing(indexPath: indexPath)
            success(true)
        })
        editAction.backgroundColor = UIColor(hue: ColorHelper.toHueFloat(deg: 220),
                                             saturation: 0.7,
                                             brightness: ColorHelper.maxColorArgValue,
                                             alpha: ColorHelper.maxColorArgValue)
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.requestTaskRemoval(indexPath: indexPath)
            success(true)
        })
        deleteAction.backgroundColor = UIColor(hue: ColorHelper.minColorArgValue,
                                               saturation: 0.7,
                                               brightness: ColorHelper.maxColorArgValue,
                                               alpha: ColorHelper.maxColorArgValue)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
extension DashboardViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionCellIdentifier, for: indexPath) as! TaskCardViewCell
        let task = data[indexPath.row]
        cell.title = task.title
        cell.desc = task.desc
        cell.dueDate = dashboardPresenter?.formatDueDateString(dueDate: task.dueDate)
        cell.cardView.backgroundColor = dashboardPresenter?.getCellColorByDueDate(dueDate: task.dueDate)
        
        cell.onMoreTap = {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
                self.requestTaskEditing(indexPath: indexPath)
            }
            alertController.addAction(editAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.requestTaskRemoval(indexPath: indexPath)
            }
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
        }
        return cell
    }
    
    
}
