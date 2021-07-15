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
    private let itemOperationsQueue = DispatchQueue(label: "com.AnyDo.itemOperationsQueue", qos: .userInitiated, attributes: [.concurrent])

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
            let dataBaseURL = URL(fileURLWithPath: dataBaseFileName, relativeTo: directoryURL)
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
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                self.toDoItemsData.append(toDoItem)
                try self.dataBase?.run(self.toDoItemsTable.insert(toDoItem))
                self.delegate?.storageServiceOnArrayDidChange(self)
                print("succesfully saved item to database")
            } catch {
                print(error)
                print("Error while saving DB")
            }
        }
    }

    func deleteToDoItem(with id: String) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                self.toDoItemsData.removeAll(where: { $0.id == id })
                let itemToDelete = self.toDoItemsTable.filter(self.id == id)
                try self.dataBase?.run(itemToDelete.delete())
                self.delegate?.storageServiceOnArrayDidChange(self)
            } catch {
                print("Error while deleting from database")
            }
        }
    }

    func updateToDoItem(todoItem: ToDoItem) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.dataBase?.run(self.toDoItemsTable.filter(self.id == todoItem.id).update(todoItem))
                self.loadAllToDoItems {
                    self.delegate?.storageServiceOnArrayDidChange(self)
                }
            } catch {
                print("Error while updating element")
            }
        }
    }

    func saveToDoItemsFromServer(items: [ToDoItem], completion: @escaping EmptyCompletion) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            self.toDoItemsData = []
            do {
                try self.dataBase?.run(self.toDoItemsTable.delete())
                for item in items {
                    self.toDoItemsData.append(item)
                    try self.dataBase?.run(self.toDoItemsTable.insert(item))
                }
                completion(.success(()))
            } catch {
                print("Error while saving all tasks to data base")
                completion(.failure(DataBaseErrors.saveItemsFromServerError))
            }
        }
    }

    func loadAllToDoItems(completion: @escaping () -> Void) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self,
                  let dataBase = self.dataBase
            else {
                print("Data base is nil")
                return
            }
            do {
                let lodadedToDoItems: [ToDoItem] = try dataBase.prepare(self.toDoItemsTable).map({ return try $0.decode() })
                self.toDoItemsData = lodadedToDoItems
                completion()
                return
            } catch {
                print(error)
                print("Error while loading all tasks from data base")
                return
            }
        }
    }

    func makeAllToDoItemsNotDirty(completion: @escaping EmptyCompletion) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.dataBase?.run(self.toDoItemsTable.update(self.isDirty <- false))
                completion(.success(()))
            } catch {
                completion(.failure(DataBaseErrors.updateTableError))
            }
        }
    }

    // MARK: Tombstones

    func addTombstone(tombstone: Tombstone) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.dataBase?.run(self.tombstonesTable.insert(tombstone))
                print("Succesfully saved item to database")
            } catch {
                print("Error while saving DB")
            }
        }
    }

    func deleteAllTombstones() {
        itemOperationsQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.dataBase?.run(self.tombstonesTable.delete())
                print("Successfully deleted all tombstones from data base")
            } catch {
                print("Error while deleting all tombstones data base")
            }
        }
    }

    func loadAllTombstones(completion: @escaping () -> Void) {
        itemOperationsQueue.async { [weak self] in
            guard let self = self,
                  let dataBase = self.dataBase
            else {
                print("Data base is nil")
                return
            }
            do {
                let lodadedTomsstones: [Tombstone] = try dataBase.prepare(self.tombstonesTable).map({ try $0.decode() })
                self.tombstonesData = lodadedTomsstones
                print("Successfully loaded all tombstones from data base")
                completion()
            } catch {
                print("Error while loading all tasks from data base")
                return
            }
        }
    }

}
