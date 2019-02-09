//
//  ViewController.swift
//  TaskManager
//
//  Created by User on 08/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var taskTableView: UITableView!
    let taskCellIdentifier = "TaskTableViewCell"
    var data: [Task] = [Task(name: "Name1NameNoNo", desc: "description", dueDate: Date())]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier, for: indexPath) as! TaskTableViewCell
        print("Creating cells")
        cell.titleLabel?.text = data[indexPath.row].name
        cell.descLabel?.text = data[indexPath.row].desc
        cell.dateLabel?.text = "Due to \(data[indexPath.row].dueDate.description)"
        print(cell.titleLabel?.text)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        saveDataToPlist()
//        data.removeAll()
        data = loadDataFromPlist();
        
        taskTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Workable function for loading data from data.plist
    func loadDataFromPlist() -> [Task]{
        if  let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let tasks = try? PropertyListDecoder().decode([Task].self, from: xml)
        {
            print("Count: \(tasks.count)")
            return tasks
        }
        return [Task]()
    }
    
    //Unworkable function for writing data to data.plist
    //The data writes completely, but file didn't rewrite.
    func saveDataToPlist(){
        do {
            let path = Bundle.main.path(forResource: "data", ofType: "plist")
            let plistEncoder = PropertyListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(self.data)
            print(NSURL.fileURL(withPath: path!))
            print(path!)
            try plistData.write(to: NSURL.fileURL(withPath: path!))
            print("Complete!")
        }
        catch
        {
            print(error)
        }
    
    }
    
    @IBAction func createTaskButton_click(_ sender: Any) {
        //button for creating new task (with alert dialog analogue)
    }
    
}

