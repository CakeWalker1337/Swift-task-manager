//
//  DateHelperTests.swift
//  TaskManagerTests
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import XCTest
@testable import TaskManager

class DateHelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFormatDateToRemainingTimeStringFormat() {
        let deviation = 10
        var assertDate = Date()
        var value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("now", value)
        assertDate.addTimeInterval(TimeInterval(DateHelper.SecondsInMinute + deviation))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1m left", value)
        assertDate.addTimeInterval(TimeInterval(DateHelper.SecondsInHour))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1h 1m left", value)
        assertDate.addTimeInterval(TimeInterval(DateHelper.SecondsInDay))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1d 1h 1m left", value)
        assertDate.addTimeInterval(TimeInterval(DateHelper.SecondsInMonth))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1M 1d 1h 1m left", value)
        assertDate.addTimeInterval(TimeInterval(DateHelper.SecondsInYear))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1Y 1M 1d 1h 1m left", value)

        assertDate = Date()
        assertDate.addTimeInterval(TimeInterval(-DateHelper.SecondsInMinute - deviation))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1m ago", value)
        assertDate.addTimeInterval(TimeInterval(-DateHelper.SecondsInHour))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1h 1m ago", value)
        assertDate.addTimeInterval(TimeInterval(-DateHelper.SecondsInDay))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1d 1h 1m ago", value)
        assertDate.addTimeInterval(TimeInterval(-DateHelper.SecondsInMonth))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1M 1d 1h 1m ago", value)
        assertDate.addTimeInterval(TimeInterval(-DateHelper.SecondsInYear))
        value = DateHelper.formatDateToRemainingTimeStringFormat(date: assertDate)
        XCTAssertEqual("1Y 1M 1d 1h 1m ago", value)
    }

}
