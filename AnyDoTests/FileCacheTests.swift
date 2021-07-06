////
////  FileCacheTests.swift
////  AnyDoTests
////
////  Created by Анас Бен Мустафа on 6/11/21.
////
//
//import XCTest
//@testable import AnyDo
//
//class FileCacheTests: XCTestCase {
//
//    var fc: FileCacheImplementation!
//
//    override func setUp() {
//        super.setUp()
//        fc = FileCacheImplementation(cacheFileName: "test0")
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        fc = nil
//    }
//
//    func testAddTask() {
//        XCTAssertTrue(fc.toDoItemsData.count == 0)
//        fc.addToDoItem(toDoItem: ToDoItem(text: "1", importance: .standart, deadLine: nil, status: .completed))
//        fc.addToDoItem(toDoItem: ToDoItem(text: "2", importance: .standart, deadLine: nil, status: .completed))
//        XCTAssertTrue(fc.toDoItemsData.count == 2)
//    }
//
//    func testDeleteTask() {
//        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id", text: "", importance: .standart, deadLine: nil, status: .uncompletedImportant))
//        XCTAssertTrue(fc.toDoItemsData.count == 1)
//        fc.deleteTask(with: "test_id")
//        XCTAssertTrue(fc.toDoItemsData.count == 0)
//    }
//
//    func testSaveLoadAllTasks() {
//        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id0", text: "task1", importance: .standart, deadLine: nil, status: .completed))
//        fc.addToDoItem(toDoItem: ToDoItem(id: "test_id1", text: "task2", importance: .important, deadLine: Date(), status: .uncompleted))
//
//        let fc1: FileCacheImplementation = FileCacheImplementation(cacheFileName: "")
//        fc1.loadAllTasks(fileName: "test3")
//        XCTAssertEqual(fc1.toDoItemsData.count, 2)
//
//        for elem in fc1.toDoItemsData {
//            print(elem.value.text)
//        }
//    }
//
//}
