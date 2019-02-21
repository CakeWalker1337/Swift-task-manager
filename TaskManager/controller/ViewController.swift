//
//  ViewController.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var taskTableView: UITableView!
    let taskCellIdentifier = "TaskTableViewCell"
    var data: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        saveDataToPlist()
//        data.removeAll()
        data = loadDataFromPlist()
        
        taskTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    /// Workable function for loading data from data.plist
    private func loadDataFromPlist() -> [Task] {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let tasks = try? PropertyListDecoder().decode([Task].self, from: xml)
        {
            print("Count: \(tasks.count)")
            return tasks
        }
        return [Task]()
    }
    
    /// Workable function for writing data to data.plist
    private func saveDataToPlist() {
        do {
            let path = Bundle.main.path(forResource: "data", ofType: "plist")
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(self.data)
            print(NSURL.fileURL(withPath: path!))
            print(path!)
            try plistData.write(to: NSURL.fileURL(withPath: path!))
            print("Complete!")
        } catch {
            print(error)
        }
    
    }
    
    /// CreateTaskButton event callback method
    @IBAction private func createTaskButtonDidClick(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlertView") as! CreateTaskAlertViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier, for: indexPath) as! TaskTableViewCell
        print("Creating cell")
        cell.task = data[indexPath.row]
        return cell
    }
    
}
/// Implementation of the delegate for createTaskAlertView callback methods.
extension ViewController: CreateTaskAlertViewControllerDelegate{
    
    func createTaskAlertViewControllerDidClickCancel(_ controller: CreateTaskAlertViewController) {
        print("Canceled")
    }
    
    func createTaskAlertViewControllerDidClickCreateTask(_ controller: CreateTaskAlertViewController, didCreate task: Task) {
        data.append(task)
        self.taskTableView.reloadData()
        saveDataToPlist()
        print("Added")
    }
    
}

