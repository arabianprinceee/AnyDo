//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCacheDelegate: AnyObject {

    func onArrayDidChanged(_ sender: FileCacheImplementation)

}

protocol FileCache {

    var delegate: FileCacheDelegate? { get set }
    var toDoItems: [String: ToDoItem] { get }
    
    func addToDoItem(toDoItem: ToDoItem)
    func deleteTask(with id: String)
    func saveAllTasks()
    func loadAllTasks(fileName: String, completion: @escaping () -> Void)
    
}
