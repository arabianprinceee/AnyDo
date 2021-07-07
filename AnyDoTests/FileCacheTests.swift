//
//  FileCacheTests.swift
//  AnyDoTests
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import XCTest
@testable import AnyDo

class FileCacheTests: XCTestCase {

    var fc: FileCacheServiceImplementation!

    override func setUp() {
        super.setUp()
        fc = FileCacheServiceImplementation(cacheFileName: "test0", tombstonesFileName: "tombstonesTest0")
    }

    override func tearDown() {
        super.tearDown()
        fc = nil
    }

    func testAddTask() {
        XCTAssertTrue(fc.toDoItemsData.count == 0)
        fc.addToDoItem(toDoItem: ToDoItem(id: "123", text: "", importance: .important, deadLine: nil, status: .uncompleted, createdAt: 0, updatedAt: nil, isDirty: true))
        XCTAssertTrue(fc.toDoItemsData.count == 1)
    }

    func testDeleteTask() {
        fc.addToDoItem(toDoItem: ToDoItem(id: "123", text: "", importance: .important, deadLine: nil, status: .uncompleted, createdAt: 0, updatedAt: nil, isDirty: true))
        XCTAssertTrue(fc.toDoItemsData.count == 1)
        fc.deleteTask(with: "123")
        XCTAssertTrue(fc.toDoItemsData.count == 0)
    }

    func testSaveLoadAllTasks() {
        let fc1 = FileCacheServiceImplementation(cacheFileName: "test00", tombstonesFileName: "tombstonesTest00")

        fc1.addToDoItem(toDoItem: ToDoItem(id: "123", text: "", importance: .important, deadLine: nil, status: .uncompleted, createdAt: 0, updatedAt: nil, isDirty: true))

        fc1.loadAllTasks(fileName: fc1.cacheFileName) {
            XCTAssertEqual(fc1.toDoItemsData.count, 1)
        }
    }

}
