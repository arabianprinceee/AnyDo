//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCache {
    
    var toDoItems: [String: ToDoItemImplementation] { get }
    
    func addTask(toDoItem: ToDoItemImplementation)
    func deleteTask(with id: String)
    func saveAllTasks(fileName: String)
    func loadAllTasks(fileName: String)
    
}
