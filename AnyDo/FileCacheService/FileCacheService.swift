//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCacheServiceDelegate: AnyObject {

    func onArrayDidChange(_ sender: FileCacheServiceImplementation)
}

protocol FileCacheService {

    var delegate: FileCacheServiceDelegate? { get set }
    var toDoItemsData: [String: ToDoItem] { get }
    var tombstonesData: [Tombstone] { get }
    
    func addToDoItem(toDoItem: ToDoItem)
    func deleteTask(with id: String)
    func saveAllTasks()
    func saveItemsFromServer(items: [ToDoItem])
    func loadAllTasks(fileName: String, completion: @escaping () -> Void)
    func addTombstone(tombstone: Tombstone)
    func deleteTombstone(with id: String)
}

enum ParsingErrors: Error {

    case encodingError
    case decodingError

}

enum FileWorkErrors: Error {

    case readFileError
    case writeToFileError

}
