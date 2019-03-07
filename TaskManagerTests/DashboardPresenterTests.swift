//
//  DashboardPresenterTests.swift
//  TaskManagerTests
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import XCTest
@testable import TaskManager

class DashboardPresenterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSortTasks() {
        let currentDate = Date()
        let task1 = Task(objectId: nil, title: "Task1", desc: "Desc1", dueDate: currentDate.addingTimeInterval(TimeInterval(1000)))
        let task2 = Task(objectId: nil, title: "Task2", desc: "Desc2", dueDate: currentDate.addingTimeInterval(TimeInterval(-1000)))
        let task3 = Task(objectId: nil, title: "Task3", desc: "Desc3", dueDate: currentDate.addingTimeInterval(TimeInterval(1000000)))
        let task4 = Task(objectId: nil, title: "Task4", desc: "Desc4", dueDate: currentDate.addingTimeInterval(TimeInterval(-1000000)))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        let presenter = DashboardPresenter(dashboardDelegate: controller as? DashboardViewControllerDelegate)
        var data = [task1, task2, task3, task4]
        presenter.sortTasks(tasks: &data)
        XCTAssertTrue(data.elementsEqual([task1, task3, task2, task4], by: {(element1: Task, element2: Task) -> Bool in
            return element1 == element2
        }))

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
