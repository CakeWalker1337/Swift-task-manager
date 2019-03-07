//
//  DashboardTaskMapperTests.swift
//  TaskManagerTests
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import XCTest
@testable import TaskManager

class DashboardTaskMapperTests: XCTestCase {

    var repo: DashboardRepository?

    override func setUp() {
        super.setUp()
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        repo = DashboardRepository(context: context)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMapTaskFromEntity() {
        let taskEntity = repo!.createNewTaskEntity()
        taskEntity.title = "test title"
        taskEntity.desc = "test desc"
        taskEntity.dueDate = Date()
        let task = DashboardTaskMapper.mapTaskFromEntity(entity: taskEntity)
        XCTAssertTrue(task.objectId == taskEntity.objectID)
        XCTAssertTrue(task.title == taskEntity.title)
        XCTAssertTrue(task.desc == taskEntity.desc)
        XCTAssertTrue(task.dueDate == taskEntity.dueDate)
    }

    func testMapTaskToEntity() {

        var taskEntity = repo!.createNewTaskEntity()
        let task = Task(objectId: taskEntity.objectID, title: "test title", desc: "test desc", dueDate: Date())
        DashboardTaskMapper.mapTaskToEntity(task: task, entity: &taskEntity)

        XCTAssertTrue(task.objectId == taskEntity.objectID)
        XCTAssertTrue(task.title == taskEntity.title)
        XCTAssertTrue(task.desc == taskEntity.desc)
        XCTAssertTrue(task.dueDate == taskEntity.dueDate)
    }

}
