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

/// The protocol to provide some operable view methods to the presentation layer.
protocol DashboardViewControllerDelegate: class {

    /// Provides managed object context.
    ///
    /// - Returns: managed object context
    func provideManagedObjectContext() -> NSManagedObjectContext
}

/// The dashboard view controller manages two main data containers
class DashboardViewController: UIViewController {

    var dashboardPresenter: DashboardPresenterDelegate?
    @IBOutlet private weak var dashboardCollectionView: UICollectionView!
    @IBOutlet private weak var dashboardTableView: UITableView!
    /// The data array for displaying tasks on the dashboard through the containers.
    private var data: [Task] = []

    private let taskTableCellIdentifier = "TaskTableViewCell"
    private let taskCollectionCellIdentifier = "TaskCardViewCell"
    private let taskInfoViewControllerIdentifier = "TaskInfoViewController"

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
        }

    }

    @IBAction private func createTaskButtonDidClick(_ sender: Any) {
        if let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: taskInfoViewControllerIdentifier)
            as? TaskInfoViewController {
            taskViewController.delegate = self
            self.navigationController?.pushViewController(taskViewController, animated: true)
        }
    }

    /// The function for updating data inside
    func updateTaskContainers() {
        dashboardTableView.reloadData()
        dashboardCollectionView.reloadData()
    }

    /// Requests for remove the task by index path
    ///
    /// - Parameter indexPath: index path of the task
    func requestTaskRemoval(indexPath: IndexPath) {
//        print("Request to remove ind \(indexPath.row)")
        self.dashboardPresenter!.deleteTask(task: self.data[indexPath.row])
        self.data.remove(at: indexPath.row)
        updateTaskContainers()
//        self.dashboardTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        self.dashboardCollectionView.deleteItems(at: [indexPath])
    }

    /// Requests for edit the task by index path
    ///
    /// - Parameter indexPath: index path of the task
    func requestTaskEditing(indexPath: IndexPath) {
        if let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: taskInfoViewControllerIdentifier)
            as? TaskInfoViewController {
            taskViewController.delegate = self
            taskViewController.setInitData(rowPath: indexPath, task: self.data[indexPath.row])
            self.navigationController?.pushViewController(taskViewController, animated: true)
        }
    }

}
extension DashboardViewController: DashboardViewControllerDelegate {
    func provideManagedObjectContext() -> NSManagedObjectContext {
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
}

extension DashboardViewController: TaskInfoViewControllerDelegate {

    func taskInfoViewController(_ controller: TaskInfoViewController, didUpdate task: Task, at rowPath: IndexPath?) {
        if controller.workMode == TaskInfoViewController.WorkMode.createTask {
            let newTask = dashboardPresenter!.insertTask(task: task)
            data.append(newTask)

        } else if controller.workMode == TaskInfoViewController.WorkMode.editTask {
            self.data[rowPath!.row] = task
            self.dashboardPresenter!.updateTask(task: task)
        }
        self.dashboardPresenter?.sortTasks(tasks: &data)
        self.updateTaskContainers()
    }
}
extension DashboardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellIdentifier, for: indexPath) as? TaskTableViewCell {
            let task = data[indexPath.row]
            cell.title = task.title
            cell.desc = task.desc
            cell.dueDate = dashboardPresenter?.formatDueDateString(dueDate: task.dueDate)
            cell.backgroundColor = dashboardPresenter?.calculateCellColorByDueDate(dueDate: task.dueDate)
            return cell
        }
        fatalError("Can't create table view cell.")
    }

}
extension DashboardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return UISwipeActionsConfiguration()
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

//        print("Table row with index \(indexPath.row) has been swiped!")
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit",
                                            handler: { (_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
            self.requestTaskEditing(indexPath: indexPath)
            success(true)
        })
        editAction.backgroundColor = UIColor(hue: ColorHelper.toHueFloat(deg: 220),
                                             saturation: 0.7,
                                             brightness: ColorHelper.maxColorArgValue,
                                             alpha: ColorHelper.maxColorArgValue)

        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete",
                                              handler: { (_:UIContextualAction, _:UIView, success: (Bool) -> Void) in
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
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionCellIdentifier, for: indexPath)
            as? TaskCardViewCell {
            if cell.title == nil {
                let task = data[indexPath.row]
                cell.title = task.title
                cell.desc = task.desc
                cell.dueDate = dashboardPresenter?.formatDueDateString(dueDate: task.dueDate)
                cell.cardBackgroundColor = dashboardPresenter?.calculateCellColorByDueDate(dueDate: task.dueDate)
                print("create cell")
                cell.onMoreTap = {
//                    print("Card with index \(indexPath.row) has been tapped! Count: \(self.data.count)")
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    }
                    alertController.addAction(cancelAction)
                    let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
                        self.requestTaskEditing(indexPath: indexPath)
                    }
                    alertController.addAction(editAction)
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                        self.requestTaskRemoval(indexPath: indexPath)
                    }
                    alertController.addAction(deleteAction)
                    self.present(alertController, animated: true)
                }
            }
            return cell

        }
        fatalError("Can't create collection view cell.")
    }

}
