//
//  ToDoItemExtension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

extension ToDoItem {
    
    // MARK: Properties

    func syncronizationJson() -> Any {
        var dict: [String: Any] = [:]

        dict["id"] = id
        dict["text"] = text
        dict["created_at"] = createdAt
        dict["updated_at"] = updatedAt
        dict["deadline"] = deadline?.timeIntervalSince1970.toInt
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
    
}

extension Double {

    func toInt() -> Int? {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return nil
        }

        return Int(self)
    }

}
