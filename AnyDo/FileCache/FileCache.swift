//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCache {
    
    var toDoItems: [String: ToDoItem] { get }
    
    func addToDoItem(toDoItem: ToDoItem)
    func deleteTask(with id: String)
    func saveAllTasks(fileName: String)
    func loadAllTasks(fileName: String)
    
}
