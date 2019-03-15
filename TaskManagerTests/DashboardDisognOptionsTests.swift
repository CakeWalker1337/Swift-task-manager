//
//  DashboardDisognOptionsTests.swift
//  TaskManagerTests
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import XCTest
@testable import TaskManager

class DashboardDisognOptionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitDashboardDesignOptions() {
        var value = DashboardDesignOptions(rawOption: "Table")
        XCTAssertEqual(DashboardDesignOptions.table, value)
        value = DashboardDesignOptions(rawOption: "Cards")
        XCTAssertEqual(DashboardDesignOptions.cards, value)
        value = DashboardDesignOptions(rawOption: nil)
        XCTAssertEqual(DashboardDesignOptions.table, value)
        value = DashboardDesignOptions(rawOption: "abracadabra")
        XCTAssertEqual(DashboardDesignOptions.table, value)

    }

}
