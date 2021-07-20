//
//  ToDoItemImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

struct ToDoItem: Codable {

    // MARK: Properties

    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let status: TaskStatus
    let createdAt: Int
    let updatedAt: Int?
    let isDirty: Bool

    // MARK: Initialization

    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance,
         deadline: Date?,
         status: TaskStatus,
         createdAt: Int = Date().timeIntervalSince1970.toInt() ?? 0,
         updatedAt: Int? = nil,
         isDirty: Bool = false) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDirty = isDirty
    }

    private enum CodingKeys: String, CodingKey {

        case id, text, deadline, importance, isDirty
        case status = "done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)

        let importanceString = try values.decode(String.self, forKey: .importance)
        switch importanceString {
        case "important":
            importance = .important
        case "basic":
            importance = .standart
        case "low":
            importance = .unimportant
        default:
            importance = .standart
        }

        let statusBoolean: Bool = try values.decode(Bool.self, forKey: .status)
        switch statusBoolean {
        case true:
            status = .completed
        case false:
            status = importance == .important ? .uncompletedImportant : .uncompleted
        }

        if let unixDeadline = try values.decode(Int?.self, forKey: .deadline) {
            deadline = Date(timeIntervalSince1970: TimeInterval(unixDeadline))
        } else {
            deadline = nil
        }

        createdAt = try values.decode(Int.self, forKey: .createdAt)

        if let updatedAt = try values.decode(Int?.self, forKey: .deadline) {
            self.updatedAt = updatedAt
        } else {
            updatedAt = nil
        }
        do {
            isDirty = try values.decode(Bool.self, forKey: .isDirty)
        } catch {
            isDirty = false
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)

        switch importance {
        case .important:
            try container.encode("important", forKey: .importance)
        case .standart:
            try container.encode("basic", forKey: .importance)
        case .unimportant:
            try container.encode("low", forKey: .importance)
        }

        switch status {
        case .uncompletedImportant, .uncompleted:
            try container.encode(false, forKey: .status)
        case .completed:
            try container.encode(true, forKey: .status)
        }

        try container.encode(deadline, forKey: .deadline)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(isDirty, forKey: .isDirty)
    }

}

enum DictKeys {

    static let kId: String = "id"
    static let kText: String = "text"
    static let kImportance: String = "importance"
    static let kDeadline: String = "deadline"
    static let kStatus: String = "status"
    static let kCreatedAt: String = "createdAt"
    static let kUpdatedAt: String = "updatedAt"
    static let kIsDirty: String = "isDirty"

}

enum Importance: String, Codable {
    
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

enum TaskStatus: String, Codable {

    case uncompletedImportant
    case uncompleted
    case completed

}
