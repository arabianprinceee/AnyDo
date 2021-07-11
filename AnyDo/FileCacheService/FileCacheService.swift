//
//  FileCache.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/10/21.
//

import Foundation

protocol FileCacheService {

    var delegate: StorageServiceDelegate? { get set }
    var toDoItemsData: [String: ToDoItem] { get }
    var tombstonesData: [Tombstone] { get }
    var cacheFileName: String { get }

    func addToDoItem(toDoItem: ToDoItem)
    func deleteTask(with id: String)
    func saveAllTasks()
    func deleteAllTombstones()
    func saveItemsFromServer(items: [ToDoItem], completion: @escaping () -> Void) 
    func loadAllTasks(fileName: String, completion: @escaping () -> Void)
    func addTombstone(tombstone: Tombstone)
    func makeAllTasksNotDirty(completion: @escaping () -> Void)
    func loadAllTombstones(completion: @escaping () -> Void)
    
}

enum ParsingErrors: Error {

    case encodingError
    case decodingError

}

enum FileWorkErrors: Error {

    case readFileError
    case writeToFileError

}
