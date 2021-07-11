//
//  FileCacheTests.swift
//  AnyDoTests
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import XCTest
@testable import AnyDo

class FileCacheTests: XCTestCase {

    var sm: StorageServiceImplementation!

    override func setUp() {
        super.setUp()
        sm = StorageServiceImplementation(dataBaseFileName: "testdb")
    }

    override func tearDown() {
        super.tearDown()
        sm = nil
    }

    func additem() {
        sm.addToDoItem(toDoItem: ToDoItem(text: "text", importance: .important, deadLine: nil, status: .completed))
        sm.loadAllToDoItems { result in
            switch result {
            case .success():
                for item in self.sm.toDoItemsData {
                    print("\n\(item)")
                }
            case .failure(_):
                print("error")
            }
        }
        XCTAssertTrue(true)
    }

}
