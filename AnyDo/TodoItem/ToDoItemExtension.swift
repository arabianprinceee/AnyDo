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
        
        dict["id"] = self.id
        dict["text"] = self.text
        
        switch self.importance {
        case .important, .unimportant:
            dict["importance"] = self.importance.rawValue
        case .standart:
            break
        }
        
        if self.deadline != nil {
            dict["deadline"] = deadline?.timeIntervalSince1970
        }
        
        return dict
    }
    
    
    // MARK: Methods
    
    static func parse(json: Any) -> ToDoItem? {
        
        let id: String
        let text: String
        let importance: Importance
        
        guard let dict = json as? [String : Any] else { return nil }
        
        if let _id = dict["id"] as? String, let _text = dict["text"] as? String {
            id = _id
            text = _text
        } else {
            return nil
        }
        
        if let _importance = dict["importance"] as? String {
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
        
        let deadline = (dict["deadline"] as? Double).map { Date(timeIntervalSince1970: $0) }
        return ToDoItem(id: id, text: text, importance: importance, deadLine: deadline)
    }
    
}
