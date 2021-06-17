//
//  FileCacheTests.swift
//  AnyDoTests
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import XCTest
@testable import AnyDo

class FileCacheTests: XCTestCase {
    
    var fc: FileCacheImplementation!
    
    override func setUp() {
        super.setUp()
        fc = FileCacheImplementation()
    }
    
    override func tearDown() {
        super.tearDown()
        fc = nil
    }
    
    func testAddTask() {
        XCTAssertTrue(fc.toDoItems.count == 0)
        fc.addToDoItem(toDoItem: ToDoItem(id: "", text: "", importance: .standart, deadLine: nil))
        XCTAssertTrue(fc.toDoItems.count == 1)
    }
    
    func testDeleteTask() {
        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id", text: "", importance: .standart, deadLine: nil))
        XCTAssertTrue(fc.toDoItems.count == 1)
        fc.deleteTask(with: "test_id")
        XCTAssertTrue(fc.toDoItems.count == 0)
    }
    
    func testSaveLoadAllTasks() {
        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id0", text: "", importance: .standart, deadLine: nil))
        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id1", text: "text1", importance: .important, deadLine: Date()))
        fc.saveAllTasks(fileName: "test_file")
        
        let fc1: FileCacheImplementation = FileCacheImplementation()
        fc1.loadAllTasks(fileName: "test_file")
        XCTAssertEqual(fc1.toDoItems.count, 2)
    }
    
}
