//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCache {
    
    var toDoItems: [String: ToDoItem] { get }
    
    func addToDoItem(toDoItem: ToDoItem, fileName: String)
    func deleteTask(with id: String, fileName: String)
    func saveAllTasks(fileName: String)
    func loadAllTasks(fileName: String)
    
}
