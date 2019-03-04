//
//  NoticesDesignOptions.swift
//  TaskManager
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

public enum DashboardDesignOptions : String, CaseIterable {
    case table = "Table"
    case cards = "Cards"
}
extension DashboardDesignOptions {
    init(rawOption: String?) {
        self = DashboardDesignOptions(rawValue: rawOption ?? "") ?? .table
    }
}
