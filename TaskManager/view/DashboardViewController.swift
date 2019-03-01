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
        data = dashboardPresenter!.fetchTasksFromDB()
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self
        dashboardCollectionView.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentNoticeDesignValue = UserDefaults.standard.object(forKey: "TasksDesignOptionValue") as? String ?? "Table"
        print(currentNoticeDesignValue)
        let designOption = DashboardDesignOptions.init(rawValue: currentNoticeDesignValue)
        if designOption == DashboardDesignOptions.Cards {
            dashboardCollectionView.isHidden = false
            dashboardTableView.isHidden = true
        }
        else if designOption == DashboardDesignOptions.Table {
            dashboardCollectionView.isHidden = true
            dashboardTableView.isHidden = false
        }
    }
    
    @IBAction private func createTaskButtonDidClick(_ sender: Any) {
        let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskInfoViewController
        taskViewController.delegate = self
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func updateTaskContainers(){
        dashboardTableView.reloadData()
        dashboardCollectionView.reloadData()
    }
}

extension DashboardViewController: DashboardViewControllerDelegate {
    func getManagedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension DashboardViewController: TaskInfoViewControllerDelegate{
    
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: TaskInfoViewController, task: TaskEntity) {
        if controller.workMode == TaskInfoViewController.WorkMode.CreateTask {
            
            print("Attempt to create Task")
        }
        else if controller.workMode == TaskInfoViewController.WorkMode.EditTask {
            print("Attempt to edit Task")
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
            let taskCell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskInfoViewController
            taskViewController.delegate = self
//            taskViewController.task = taskCell.task
            
            self.navigationController?.pushViewController(taskViewController, animated: true)
        })
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete ...")
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
//        cell.task = data[indexPath.row]
        print("Creating collection cell")
        return cell
    }
    
    
}
