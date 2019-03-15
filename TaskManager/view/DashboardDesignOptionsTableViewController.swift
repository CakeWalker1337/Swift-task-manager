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

    @IBOutlet private var optionsTableView: UITableView!
    private let optionsCellsIdentifier = "NoticeOptionsDesignTableViewCell"
    weak var optionsDelegate: DashboardDesignOptionsTableViewDelegate?

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
        cell.textLabel?.text = DashboardDesignOptions.allCases[indexPath.row].rawValue
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.optionsDelegate?.onPushingResult(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
}

/// Dashboard Design options view delegate. Provides callback when a new option has been chosen.
protocol DashboardDesignOptionsTableViewDelegate: class {
    /// Stores chosen design option to the configuration.
    ///
    /// - Parameter indexPath: index path to chosen design option.
    func onPushingResult(indexPath: IndexPath)
}
