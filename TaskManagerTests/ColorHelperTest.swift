//
//  ColorHelperTest.swift
//  TaskManagerTests
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

@testable import TaskManager
import XCTest

class ColorHelperTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculateCellColorByDueDate() {
        var assertDate = Date(timeInterval: TimeInterval(integerLiteral: 100000000), since: Date())
        var value = ColorHelper.calculateCellColorByDueDate(dueDate: assertDate)
        var assertColor = UIColor(hue: ColorHelper.toHueFloat(deg: 130), saturation: 0.4, brightness: 1.0, alpha: 1.0)
        XCTAssertEqual(assertColor, value)

        assertDate = Date()
        value = ColorHelper.calculateCellColorByDueDate(dueDate: assertDate)
        assertColor = UIColor(hue: ColorHelper.toHueFloat(deg: 0), saturation: 0.4, brightness: 1.0, alpha: 1.0)
        XCTAssertEqual(assertColor, value)

        assertDate = Date(timeInterval: TimeInterval(integerLiteral: -1000), since: Date())
        value = ColorHelper.calculateCellColorByDueDate(dueDate: assertDate)
        assertColor = UIColor.gray
        XCTAssertEqual(assertColor, value)
    }

    func testToHueFloat() {
        var assertDegree = 360
        XCTAssertEqual(1.0, ColorHelper.toHueFloat(deg: assertDegree))
        assertDegree = 213123
        XCTAssertEqual(1.0, ColorHelper.toHueFloat(deg: assertDegree))
        assertDegree = -123
        XCTAssertEqual(0.0, ColorHelper.toHueFloat(deg: assertDegree))
        assertDegree = 36
        XCTAssertEqual(0.1, ColorHelper.toHueFloat(deg: assertDegree))
        assertDegree = 0
        XCTAssertEqual(0.0, ColorHelper.toHueFloat(deg: assertDegree))
    }

}
