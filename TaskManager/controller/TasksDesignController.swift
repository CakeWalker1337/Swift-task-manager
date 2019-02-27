//
//  ViewController.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit
import CoreData

class TasksDesignController: UIViewController {
    
    @IBOutlet weak var tasksCollectionView: UICollectionView!
    @IBOutlet weak var tasksTableView: UITableView!
    private var context: NSManagedObjectContext?
    private var data: [Task] = []
    
    let taskTableCellIdentifier = "TaskTableViewCell"
    private let taskCollectionCellIdentifier = "TaskCardViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        data = fetchDataFromDB()
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        tasksCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentNoticeDesignValue = UserDefaults.standard.object(forKey: "TasksDesignOptionValue") as! String
        print(currentNoticeDesignValue)
        let designOption = NoticesDesignOptions.init(rawValue: currentNoticeDesignValue)
        if designOption == NoticesDesignOptions.Cards {
            tasksCollectionView.isHidden = false
            tasksTableView.isHidden = true
        }
        else if designOption == NoticesDesignOptions.Table {
            tasksCollectionView.isHidden = true
            tasksTableView.isHidden = false
        }
    }
    
    @IBAction private func createTaskButtonDidClick(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlertView") as! CreateTaskAlertViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func fetchDataFromDB() -> [Task] {
        do {
            var fetchedResults = try context!.fetch(NSFetchRequest(entityName:"Task")) as [Task]
            fetchedResults.sort(by: {(task1: Task, task2: Task) -> Bool in
                let now = Date()
                //red task is a task which due date has gone
                let isTask1Red = task1.dueDate!.compare(now) == .orderedDescending
                let isTask2Red = task2.dueDate!.compare(now) == .orderedDescending
                // effective state checking
                if isTask1Red && isTask2Red {
                    return task1.dueDate!.compare(task2.dueDate!) == .orderedAscending
                }
                else if !isTask1Red && !isTask2Red {
                    return task1.dueDate!.compare(task2.dueDate!) == .orderedDescending
                }
                return !isTask1Red
            })
            return fetchedResults
        } catch {
            print("Failed saving")
            return []
        }
    }
    
    func updateTaskContainers(){
        tasksTableView.reloadData()
        tasksTableView.reloadData()
    }
    
}
extension TasksDesignController: CreateTaskAlertViewControllerDelegate{
    func createTaskAlertViewControllerDidClickCancel(_ controller: CreateTaskAlertViewController) {
        print("Creating task has been canceled")
    }
    
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: CreateTaskAlertViewController, title: String, desc: String, dueDate: Date) {
        
        let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context!)
        let newTask = NSManagedObject(entity: taskEntity!, insertInto: context!)
        newTask.setValue(title, forKey: "title")
        newTask.setValue(desc, forKey: "desc")
        newTask.setValue(dueDate, forKey: "dueDate")
        do {
            try context!.save()
            data = fetchDataFromDB()
            updateTaskContainers()
            print("Task was created")
        } catch {
            print("Failed saving")
        }
    }
}
extension TasksDesignController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskTableCellIdentifier, for: indexPath) as! TaskTableViewCell
        print("Creating table cell")
        cell.task = data[indexPath.row]
        return cell
    }
    
}
extension TasksDesignController: UITableViewDelegate {
    
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
            //            let taskCell = self.taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell
        })
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete ...")
            self.context?.delete(self.data[indexPath.row])
            self.data.remove(at: indexPath.row)
            self.tasksTableView.reloadData()
            success(true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
extension TasksDesignController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionCellIdentifier, for: indexPath) as! TaskCardViewCell
        cell.task = data[indexPath.row]
        print("Creating collection cell")
        
        return cell
    }
}
