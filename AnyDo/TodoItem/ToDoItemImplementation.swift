//
//  ToDoItemImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

struct ToDoItemImplementation: ToDoItem {
    
    // MARK: Properties
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    
    // MARK: Initialization
    
    init(id: String, text: String, importance: Importance, deadLine: Date?) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadLine
    }
    
}

enum Importance: String {
    
    case important = "important"
    case standart = "standart"
    case unimportant = "unimportant"
    
}
