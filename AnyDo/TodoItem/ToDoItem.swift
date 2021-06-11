//
//  ToDoItem.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol ToDoItem {
    
    var id: String { get }
    var text: String { get }
    var importance: Importance { get }
    var deadline: Date? { get }
    
}
