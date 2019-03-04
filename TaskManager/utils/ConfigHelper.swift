//
//  ConfigHelper.swift
//  TaskManager
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

class ConfigHelper {
    private static var instance: ConfigHelper?
    private var prefs: UserDefaults
    
    static func getInstance() -> ConfigHelper {
        if instance == nil {
            instance = ConfigHelper()
        }
        return instance!
    }
    
    private init(){
        prefs = UserDefaults.standard
    }
    
    func getDashboardDesignOption() -> DashboardDesignOptions {
        let stringOption = prefs.object(forKey: "DashboardDesignOptionValue") as? String
        return DashboardDesignOptions.init(rawOption: stringOption)
    }
    
    func setDashboardDesignOption(option: DashboardDesignOptions) {
        prefs.set(option.rawValue, forKey: "DashboardDesignOptionValue")
    }
    
}
