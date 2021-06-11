//
//  ToDoItemExtension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

extension ToDoItemImplementation {
    
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
    
    static func parse(json: Any) -> ToDoItemImplementation? {
        
        var id: String
        var text: String
        var importance: Importance
        
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
        
        guard let deadline = dict["deadline"] as? Double else {
            return ToDoItemImplementation(id: id, text: text, importance: importance, deadLine: nil)
        }
        
        return ToDoItemImplementation(id: id, text: text, importance: importance, deadLine: NSDate(timeIntervalSince1970: deadline) as Date)
    }
    
}
