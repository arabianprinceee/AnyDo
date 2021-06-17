//
//  FileCacheImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

final class FileCacheImplementation: FileCache {
    
    // MARK: Properties
    
    private(set) var toDoItems: [String: ToDoItem] = [:]
    let fileManager = FileManager()
    let tempDir = NSTemporaryDirectory()
    
    // MARK: Methods
    
    func addToDoItem(toDoItem: ToDoItem) {
        self.toDoItems[toDoItem.id] = toDoItem
    }
    
    func deleteTask(with id: String) {
        self.toDoItems[id] = nil
    }
    
    func saveAllTasks(fileName: String) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")
        let jsonArray = toDoItems.values.map { $0.json }
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
            try jsonData?.write(to: fileURL)
        } catch _ as NSError {
            assertionFailure("Error during saving all tasks to json")
        }
    }
    
    func loadAllTasks(fileName: String) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")
        toDoItems.removeAll()
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                let items = json.compactMap { ToDoItem.parse(json: $0) }
                for item in items {
                    toDoItems[item.id] = item
                }
            }
        } catch _ as NSError {
            assertionFailure("Error during loading all tasks from json")
        }
    }
    
}
