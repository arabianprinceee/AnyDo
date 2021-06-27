//
//  ToDoItemImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

struct ToDoItem {
    
    // MARK: Properties
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    var status: TaskStatus
    
    // MARK: Initialization
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadLine: Date?, status: TaskStatus) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadLine
        self.status = status
    }
    
}

enum DictKeys {
    static let kId: String = "id"
    static let kText: String = "text"
    static let kImportance: String = "importance"
    static let kDeadline: String = "deadline"
    static let kStatus: String = "status"
}

enum Importance: String {
    
    case important
    case standart
    case unimportant
    
}

enum TaskStatus: String {
    
    case uncompletedImportant
    case uncompleted
    case completed
    
}
