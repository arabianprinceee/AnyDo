//
//  FileCacheImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

final class FileCacheImplementation: FileCache {
    
    // MARK: Properties
    
    weak var delegate: FileCacheDelegate?
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
        delegate?.onArrayDidChanged(self)
    }
    
    func deleteTask(with id: String) {
        self.toDoItemsData[id] = nil
        saveAllTasks()
        delegate?.onArrayDidChanged(self)
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

    // MARK: Tombstone Methods

    func saveTombstone(tombstone: Tombstone) {
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
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(.failure(FileWorkErrors.writeToFileError))
            }
        }
    }

    func loadAllTombstones(completion: @escaping EmptyCompletion) {
        let loadQueue = DispatchQueue(label: "com.AnyDo.loadTombstonesQueue", qos: .background)
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: tombstonesFileName, relativeTo: directoryURL).appendingPathExtension("txt")

        loadQueue.async {
            guard self.fileManager.fileExists(atPath: fileURL.path) else {
                completion(.failure(FileWorkErrors.readFileError))
                return
            }
            self.tombstonesData.removeAll()
            do {
                let data = try Data(contentsOf: fileURL)
                let tombstones = try JSONDecoder().decode([Tombstone].self, from: data)
                self.tombstonesData = tombstones
                completion(.success(()))
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(.failure(ParsingErrors.decodingError))
            }
        }
    }

}
