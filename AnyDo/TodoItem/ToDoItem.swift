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
    let status: TaskStatus
    let createdAt: Int
    let updatedAt: Int
    let isDirty: Bool
    
    // MARK: Initialization
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance,
         deadLine: Date?,
         status: TaskStatus,
         createdAt: Int = Int(Date().timeIntervalSince1970),
         updatedAt: Int,
         isDirty: Bool = false) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadLine
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDirty = isDirty
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

extension Importance {
    var value: Int {
        switch self {
        case .unimportant:
            return 0
        case .standart:
            return 1
        case .important:
            return 2
        }
    }
}

enum TaskStatus: String {
    
    case uncompletedImportant
    case uncompleted
    case completed
    
}
