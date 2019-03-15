//
//  ConfigHelper.swift
//  TaskManager
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

/// Util class for interacting with UserDefaults configurations.
class Configuration {
    static var shared = Configuration()
    private var prefs: UserDefaults
    private let dashboardDesignOptionValueKey = "DashboardDesignOptionValue"

    /// dashboard design option value in the preferences
    var dashboardDesignOption: DashboardDesignOptions {
        set {
            prefs.set(newValue.rawValue, forKey: dashboardDesignOptionValueKey)
        }
        get {
            let stringOption = prefs.object(forKey: dashboardDesignOptionValueKey) as? String
            return DashboardDesignOptions(rawOption: stringOption)
        }
    }
    private init() {
        prefs = UserDefaults.standard
    }

}
