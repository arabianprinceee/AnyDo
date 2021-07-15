//
//  StorageService.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/11/21.
//

import Foundation

protocol StorageServiceDelegate: AnyObject {

    func storageServiceOnArrayDidChange(_ sender: StorageServiceImplementation)

}

protocol StorageService {

    var delegate: StorageServiceDelegate? { get set }
    var toDoItemsData: [ToDoItem] { get }
    var tombstonesData: [Tombstone] { get }

    func addToDoItem(toDoItem: ToDoItem)
    func deleteToDoItem(with id: String)
    func updateToDoItem(todoItem: ToDoItem)
    func saveToDoItemsFromServer(items: [ToDoItem], completion: @escaping EmptyCompletion)
    func loadAllToDoItems(completion: @escaping () -> Void)
    func makeAllToDoItemsNotDirty(completion: @escaping EmptyCompletion)

    func addTombstone(tombstone: Tombstone)
    func deleteAllTombstones()
    func loadAllTombstones(completion: @escaping () -> Void)

}

enum DataBaseErrors: Error {

    case saveItemsFromServerError
    case loadItemsFromServerError
    case updateTableError
    case dataBaseNotExistsError

}

enum ParsingErrors: Error {

    case encodingError
    case decodingError

}

enum FileWorkErrors: Error {

    case readFileError
    case writeToFileError

}
