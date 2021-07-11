//
//  DataService.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/10/21.
//

import Foundation
import SQLite

public final class StorageServiceImplementation: StorageService {

    weak var delegate: StorageServiceDelegate?
    private(set) var toDoItemsData: [ToDoItem] = []
    private(set) var tombstonesData: [Tombstone] = []

    private var dataBase: Connection? = nil
    private let toDoItemsTable = Table("ToDoItems")
    private let tombstonesTable = Table("Tombstones")
    private let dataBaseFileName: String

    private let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    /// ToDoItems table elements
    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let importance = Expression<String>("importance")
    private let deadline = Expression<Date>("deadline")
    private let done = Expression<Bool>("done")
    private let created_at = Expression<Int>("created_at")
    private let updated_at = Expression<Int?>("updated_at")
    private let isDirty = Expression<Bool>("isDirty")

    /// Tombstones table elements
    private let tombstoneId = Expression<String>("id")
    private let deletedAt = Expression<Date>("deletedAt")

    init(dataBaseFileName: String) {
        self.dataBaseFileName = dataBaseFileName
        do {
            let dataBaseURL = URL(fileURLWithPath: dataBaseFileName, relativeTo: directoryURL).appendingPathExtension("txt")
            dataBase = try Connection(dataBaseURL.absoluteString)
            print("successfully connected to database")
            try dataBase?.run(toDoItemsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(text)
                t.column(importance)
                t.column(deadline)
                t.column(done)
                t.column(created_at)
                t.column(updated_at)
                t.column(isDirty)
            })
            try dataBase?.run(tombstonesTable.create(ifNotExists: true) { t in
                t.column(tombstoneId, primaryKey: true)
                t.column(deletedAt)
            })
            print("successfully created or opened existing tables")
        } catch {
            print(error)
            assertionFailure("Error during initializing the data base or tables")
        }
    }

    // MARK: ToDoItems

    func addToDoItem(toDoItem: ToDoItem) {
        do {
            toDoItemsData.append(toDoItem)
            try dataBase?.run(toDoItemsTable.insert(toDoItem))
            delegate?.storageServiceOnArrayDidChange(self)
            print("succesfully saved item to database")
        } catch {
            print(error)
            print("Error while saving DB")
        }
    }

    func deleteToDoItem(with id: String) {
        do {
            toDoItemsData.removeAll(where: { $0.id == id })
            let itemToDelete = toDoItemsTable.filter(self.id == id)
            try dataBase?.run(itemToDelete.delete())
            delegate?.storageServiceOnArrayDidChange(self)
        } catch {
            print("Error while deleting from database")
        }
    }

    func updateToDoItem(todoItem: ToDoItem) {
        do {
            try dataBase?.run(toDoItemsTable.filter(id == todoItem.id).update(todoItem))
            loadAllToDoItems { result in
                switch result {
                case .success():
                    self.delegate?.storageServiceOnArrayDidChange(self)
                case .failure(_):
                    print("Error during update item")
                }
            }
            delegate?.storageServiceOnArrayDidChange(self)
        } catch {
            print("Error while updating element")
        }
    }

    func saveToDoItemsFromServer(items: [ToDoItem], completion: @escaping EmptyCompletion) {
        self.toDoItemsData = []
        do {
            try dataBase?.run(toDoItemsTable.delete())
            for item in items {
                addToDoItem(toDoItem: item)
            }
            completion(.success(()))
        } catch {
            print("Error while saving all tasks to data base")
            completion(.failure(DataBaseErrors.saveItemsFromServerError))
        }
    }

    func loadAllToDoItems(completion: @escaping EmptyCompletion) {
        guard let dataBase = dataBase else {
            print("data base is nil")
            completion(.failure(DataBaseErrors.dataBaseNotExistsError))
            return
        }
        do {
            let lodadedToDoItems: [ToDoItem] = try dataBase.prepare(toDoItemsTable).map({ try $0.decode() })
            self.toDoItemsData = lodadedToDoItems
            completion(.success(()))
        } catch {
            print("Error while loading all tasks from data base")
            completion(.failure(DataBaseErrors.loadItemsFromServerError))
        }
    }

    func makeAllToDoItemsNotDirty(completion: @escaping EmptyCompletion) {
        do {
            try dataBase?.run(toDoItemsTable.update(isDirty <- false))
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseErrors.updateTableError))
        }
    }

    // MARK: Tombstones

    func addTombstone(tombstone: Tombstone) {
        do {
            try dataBase?.run(tombstonesTable.insert(tombstone))
            print("succesfully saved item to database")
        } catch {
            print("Error while saving DB")
        }
    }

    func deleteAllTombstones() {
        do {
            try dataBase?.run(toDoItemsTable.delete())
            print("successfully deleted all tombstones from data base")
        } catch {
            print("Error while deleting all tombstones data base")
        }
    }

    func loadAllTombstones(completion: @escaping EmptyCompletion) {
        guard let dataBase = dataBase else {
            print("data base is nil")
            completion(.failure(DataBaseErrors.dataBaseNotExistsError))
            return
        }
        do {
            let lodadedTomsstones: [Tombstone] = try dataBase.prepare(tombstonesTable).map({ try $0.decode() })
            self.tombstonesData = lodadedTomsstones
            print("successfully loaded all tombstones from data base")
            completion(.success(()))
        } catch {
            print("Error while loading all tasks from data base")
            completion(.failure(DataBaseErrors.loadItemsFromServerError))
        }
    }

}
