//
//  ConfigHelper.swift
//  TaskManager
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

class Configuration {
    static var shared = Configuration()
    private var prefs: UserDefaults
    
    var dashboardDesignOption: DashboardDesignOptions {
        set {
            prefs.set(newValue.rawValue, forKey: "DashboardDesignOptionValue")
        }
        get {
            let stringOption = prefs.object(forKey: "DashboardDesignOptionValue") as? String
            return DashboardDesignOptions.init(rawOption: stringOption)
        }
    }
    
    private init(){
        prefs = UserDefaults.standard
    }
}
