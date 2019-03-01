//
//  NoticesDesignOptionsTableTableViewController.swift
//  TaskManager
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class DashboardDesignOptionsTableViewController: UITableViewController {

    // MARK: - Table view data source

    @IBOutlet var optionsTableView: UITableView!
    private let optionsCellsIdentifier = "NoticeOptionsDesignTableViewCell"
    var optionsDelegate: DashboardDesignOptionsTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.optionsCellsIdentifier)
        self.optionsTableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DashboardDesignOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.optionsCellsIdentifier, for: indexPath)
        print("Creating settings cell")
        cell.textLabel?.text = DashboardDesignOptions.allCases[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.optionsDelegate?.onPushingResult(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }

}

protocol DashboardDesignOptionsTableViewDelegate {
    func onPushingResult(indexPath: IndexPath)
}
