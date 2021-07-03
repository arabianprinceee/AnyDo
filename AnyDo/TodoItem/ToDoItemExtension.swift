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

    // MARK: Methods

    static func parse(json: Any) -> ToDoItem? {

        let id: String
        let text: String
        let status: TaskStatus
        let importance: Importance

        guard let dict = json as? [String : Any] else { return nil }

        if let tmpId = dict[DictKeys.kId] as? String, let tmpText = dict[DictKeys.kText] as? String {
            id = tmpId
            text = tmpText
        } else {
            return nil
        }
        
        if let tmpStatus = dict[DictKeys.kStatus] as? String {
            switch tmpStatus {
            case TaskStatus.completed.rawValue:
                status = .completed
            case TaskStatus.uncompleted.rawValue:
                status = .uncompleted
            case TaskStatus.uncompletedImportant.rawValue:
                status = .uncompletedImportant
            default:
                return nil
            }
        } else {
            return nil
        }

        if let tmpImportance = dict[DictKeys.kImportance] as? String {
            switch tmpImportance {
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
                        updatedAt: Int(Date().timeIntervalSince1970))
    }

}
