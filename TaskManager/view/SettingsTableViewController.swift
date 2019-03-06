//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// Settings table view controller. Displays settings in table form.
class SettingsTableViewController: UITableViewController {

    @IBOutlet private weak var settingsTableView: UITableView!
    private var settingNames = ["Notices table design"]
    private let settingsCellIdentifier = "SettingsTableViewCell"
    private let sectionTitles = ["Design settings"]
    private let dashboardDesignOptionsVCIdentifier = "DashboardDesignOptionsTableViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.settingsCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: settingsCellIdentifier)
        }
        cell!.textLabel?.text = self.settingNames[indexPath.row]
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let currentNoticeDesign = Configuration.shared.dashboardDesignOption
        let detailLabel = cell?.detailTextLabel
        detailLabel?.text = currentNoticeDesign.rawValue
        detailLabel?.textColor = UIColor.lightGray
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: dashboardDesignOptionsVCIdentifier)
                as? DashboardDesignOptionsTableViewController {
                    controller.optionsDelegate = self
                    self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }

}
extension SettingsTableViewController: DashboardDesignOptionsTableViewDelegate {

    func onPushingResult(indexPath: IndexPath) {
        let chosenOption = DashboardDesignOptions.allCases[indexPath.row]
        Configuration.shared.dashboardDesignOption = chosenOption
        settingsTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = chosenOption.rawValue
    }
}
