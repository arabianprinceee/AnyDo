//
//  ToDoItemExtension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

extension ToDoItem {
    
    // MARK: Properties
    
    var json: Any {
        var dict: [String: Any] = [:]
        
        dict[DictKeys.kId] = self.id
        dict[DictKeys.kText] = self.text
        dict[DictKeys.kStatus] = self.status.rawValue
        dict[DictKeys.kCreatedAt] = self.createdAt
        dict[DictKeys.kUpdatedAt] = self.updatedAt
        dict[DictKeys.kIsDirty] = self.isDirty
        
        switch self.importance {
        case .important, .unimportant:
            dict[DictKeys.kImportance] = self.importance.rawValue
        case .standart:
            break
        }
        
        if self.deadline != nil {
            dict[DictKeys.kDeadline] = deadline?.timeIntervalSince1970
        }
        
        return dict
    }

    func syncronizationJson() -> Any {
        var dict: [String: Any] = [:]

        dict["id"] = id
        dict["text"] = text
        dict["created_at"] = createdAt
        dict["updated_at"] = updatedAt
        dict["deadline"] = deadline?.timeIntervalSince1970
        dict["done"] = status == .completed ? true : false

        switch importance {
        case .important:
            dict["priority"] = "important"
        case .standart:
            dict["priority"] = "basic"
        case .unimportant:
            dict["priority"] = "low"
        }

        return dict
    }
    
    
    // MARK: Methods
    
    static func parse(json: Any) -> ToDoItem? {
        let id: String
        let text: String
        let status: TaskStatus
        let importance: Importance
        let createdAt: Int
        let updatedAt: Int?
        let isDirty: Bool
        
        guard let dict = json as? [String : Any] else { return nil }
        
        guard
            let _id = dict[DictKeys.kId] as? String,
            let _text = dict[DictKeys.kText] as? String,
            let _status = dict[DictKeys.kStatus] as? String,
            let _createdAt = dict[DictKeys.kCreatedAt] as? Int,
            let _isDirty = dict[DictKeys.kIsDirty] as? Bool
        else {
            return nil
        }

        id = _id
        text = _text
        createdAt = _createdAt
        isDirty = _isDirty

        switch _status {
        case TaskStatus.completed.rawValue:
            status = .completed
        case TaskStatus.uncompleted.rawValue:
            status = .uncompleted
        case TaskStatus.uncompletedImportant.rawValue:
            status = .uncompletedImportant
        default:
            return nil
        }

        if let _updatedAt = dict[DictKeys.kUpdatedAt] as? Int {
            updatedAt = _updatedAt
        } else {
            updatedAt = nil
        }
        
        if let _importance = dict[DictKeys.kImportance] as? String {
            switch _importance {
            case Importance.important.rawValue:
                importance = .important
            case Importance.unimportant.rawValue:
                importance = .unimportant
            default:
                importance = .standart
            }
        } else {
            importance = .standart
        }
        
        let deadline = (dict[DictKeys.kDeadline] as? Double).map { Date(timeIntervalSince1970: $0) }
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadLine: deadline,
                        status: status,
                        createdAt: createdAt,
                        updatedAt: updatedAt,
                        isDirty: isDirty)
    }
    
}
