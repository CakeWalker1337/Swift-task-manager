//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    private var settingNames = ["Notices table design"]
    private let settingsCellIdentifier = "SettingsTableViewCell"
    private let sectionTitles = ["Design settings"]
    
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
            print("Creating new setting cell")
        }
        else {
            print("Creating settings cell")
        }
        cell!.textLabel?.text = self.settingNames[indexPath.row]
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let currentNoticeDesign = UserDefaults.standard.object(forKey: "TasksDesignOptionValue")
        let detailLabel = cell?.detailTextLabel
        detailLabel?.text = currentNoticeDesign as? String
        detailLabel?.textColor = UIColor.lightGray
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NoticesDesignOptionsTableViewController") as! TasksDesignOptionsTableViewController
            controller.optionsDelegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }

}
extension SettingsTableViewController: NoticesDesignOptionsTableViewDelegate {
    func onPushingResult(indexPath: IndexPath) {
        let chosenOption = NoticesDesignOptions.allCases[indexPath.row].rawValue
        UserDefaults.standard.set(chosenOption, forKey: "TasksDesignOptionValue")
        settingsTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = chosenOption
    }
}
