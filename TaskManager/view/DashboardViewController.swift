//
//  ViewController.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit
import CoreData


protocol DashboardViewControllerDelegate {
    func getManagedObjectContext() -> NSManagedObjectContext
}


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
        let designOption = ConfigHelper.getInstance().getDashboardDesignOption()
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
    
    func updateTaskContainers(){
        dashboardTableView.reloadData()
        dashboardCollectionView.reloadData()
    }
    
    func updateTaskContainers(at path: IndexPath){
        let updatedRows = [path]
        dashboardTableView.reloadRows(at: updatedRows, with: UITableView.RowAnimation.fade)
        dashboardCollectionView.reloadItems(at: updatedRows)
    }
}

extension DashboardViewController: DashboardViewControllerDelegate {
    func getManagedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension DashboardViewController: TaskInfoViewControllerDelegate{
    
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: TaskInfoViewController, task: Task, rowPath: IndexPath?) {
        if controller.workMode == TaskInfoViewController.WorkMode.createTask {
            let newTask = dashboardPresenter!.insertTask(task: task)
            data.append(newTask)
            self.dashboardPresenter?.sortTasks(tasks: &data)
            self.updateTaskContainers()
            
        }
        else if controller.workMode == TaskInfoViewController.WorkMode.editTask {
            self.data[rowPath!.row] = task
            self.updateTaskContainers(at: rowPath!)
        }
    }
}
extension DashboardViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellIdentifier, for: indexPath) as! TaskTableViewCell
        print("Creating table cell")
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
            print("Edit ...")
            let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskInfoViewController") as! TaskInfoViewController
            taskViewController.delegate = self
            taskViewController.setInitData(rowPath: indexPath, task: self.data[indexPath.row])
            self.navigationController?.pushViewController(taskViewController, animated: true)
            success(true)
        })
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete ...")
            self.dashboardPresenter!.deleteTask(task: self.data[indexPath.row])
            self.data.remove(at: indexPath.row)
            self.dashboardTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.dashboardCollectionView.deleteItems(at: [indexPath])
            success(true)
        })
        deleteAction.backgroundColor = .red
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
        print("Creating collection cell")
        return cell
    }
    
    
}
