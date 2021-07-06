//
//  FileCacheImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

final class FileCacheServiceImplementation: FileCacheService {

    // MARK: Properties
    
    weak var delegate: FileCacheServiceDelegate?
    private(set) var toDoItemsData: [String: ToDoItem] = [:]
    private(set) var tombstonesData: [Tombstone] = []
    private let fileManager = FileManager()
    var cacheFileName: String
    var tombstonesFileName: String
    
    // MARK: Initialization
    
    init(cacheFileName: String, tombstonesFileName: String) {
        self.cacheFileName = cacheFileName
        self.tombstonesFileName = tombstonesFileName
    }
    
    // MARK: ToDoItem Methods
    
    func addToDoItem(toDoItem: ToDoItem) {
        self.toDoItemsData[toDoItem.id] = toDoItem
        saveAllTasks()
        delegate?.onArrayDidChange(self)
    }
    
    func deleteTask(with id: String) {
        self.toDoItemsData[id] = nil
        saveAllTasks()
        delegate?.onArrayDidChange(self)
    }
    
    func saveAllTasks() {
        let saveQueue = DispatchQueue(label: "com.AnyDo.saveItemsQueue", qos: .background)
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: cacheFileName, relativeTo: directoryURL).appendingPathExtension("txt")
        let jsonArray = toDoItemsData.values.map { $0.json }

        saveQueue.async {
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
                try jsonData?.write(to: fileURL)
            } catch _ as NSError {
                assertionFailure("Error during saving all tasks to json")
            }
        }
    }

    func saveItemsFromServer(items: [ToDoItem], completion: @escaping () -> Void) {
        let saveQueue = DispatchQueue(label: "com.AnyDo.saveItemsQueue", qos: .userInitiated)

        saveQueue.async {
            for item in items {
                self.toDoItemsData[item.id] = item
            }
            completion()
        }
    }
    
    func loadAllTasks(fileName: String, completion: @escaping () -> Void) {
        let loadQueue = DispatchQueue(label: "com.AnyDo.loadItemsQueue", qos: .userInitiated)
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")

        loadQueue.async {
            if self.fileManager.fileExists(atPath: fileURL.path) {
                self.toDoItemsData.removeAll()
                do {
                    let data = try Data(contentsOf: fileURL)

                    if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        let items = json.compactMap { ToDoItem.parse(json: $0) }
                        for item in items {
                            self.toDoItemsData[item.id] = item
                        }
                    }
                    completion()
                } catch let error as NSError {
                    print(error.localizedDescription)
                    assertionFailure("Error during loading all tasks from json")
                }
            }
        }
    }

    func makeAllTasksNotDirty(completion: @escaping () -> Void) {
        let toggleDirtyQueue = DispatchQueue(label: "com.AnyDo.toggleDirtyQueue", qos: .userInitiated)

        toggleDirtyQueue.async {
            for item in self.toDoItemsData.values {
                if item.isDirty {
                    self.toDoItemsData[item.id] = ToDoItem(id: item.id,
                                                           text: item.text,
                                                           importance: item.importance,
                                                           deadLine: item.deadline,
                                                           status: item.status,
                                                           createdAt: item.createdAt,
                                                           updatedAt: Int(Date().timeIntervalSince1970),
                                                           isDirty: false)
                }
            }
            completion()
        }
    }

    // MARK: Tombstone Methods

    func deleteAllTombstones() {
        tombstonesData = []
    }

    func addTombstone(tombstone: Tombstone) {
        tombstonesData.append(tombstone)
        saveAllTombstones { result in
            switch result {
            case .success():
                print("Successfully saved new tombstone")
            case .failure(_):
                break
            }
        }
    }

    func deleteTombstone(with id: String) {
        tombstonesData = tombstonesData.filter({ $0.id != id })
        saveAllTombstones { result in
            switch result {
            case .success():
                print("Successfully deleted tombstone")
            case .failure(_):
                break
            }
        }
    }

    func saveAllTombstones(completion: @escaping EmptyCompletion) {
        let saveQueue = DispatchQueue(label: "com.AnyDo.saveTombstonesQueue", qos: .background)
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: tombstonesFileName, relativeTo: directoryURL).appendingPathExtension("txt")

        saveQueue.async {
            do {
                guard let json = try? JSONEncoder().encode(self.tombstonesData) else {
                    completion(.failure(ParsingErrors.encodingError))
                    return
                }
                try json.write(to: fileURL)
                completion(.success(()))
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(.failure(FileWorkErrors.writeToFileError))
            }
        }
    }

    func loadAllTombstones(completion: @escaping () -> Void) {
        let loadQueue = DispatchQueue(label: "com.AnyDo.loadTombstonesQueue", qos: .background)
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: tombstonesFileName, relativeTo: directoryURL).appendingPathExtension("txt")

        loadQueue.async {
            if self.fileManager.fileExists(atPath: fileURL.path) {
                self.tombstonesData.removeAll()
                do {
                    let data = try Data(contentsOf: fileURL)
                    let tombstones = try JSONDecoder().decode([Tombstone].self, from: data)
                    self.tombstonesData = tombstones
                    completion()
                } catch let error as NSError {
                    print(error.localizedDescription)
                    assertionFailure("Error during loading all tombstones from json")
                }
            }
        }
    }

}
