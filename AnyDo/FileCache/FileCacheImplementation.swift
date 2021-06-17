//
//  FileCacheImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/11/21.
//

import Foundation

final class FileCacheImplementation: FileCache {
    
    // MARK: Properties
    
    var toDoItems: [String: ToDoItemImplementation] = [:]
    let fileManager = FileManager()
    let tempDir = NSTemporaryDirectory()
    
    // MARK: Methods
    
    func addTask(toDoItem: ToDoItemImplementation) {
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
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func loadAllTasks(fileName: String) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("txt")
        toDoItems.removeAll()
        
        do {
            let data = try Data(contentsOf: fileURL)
            if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                for subjson in json {
                    if let id = subjson["id"] as? String {
                        toDoItems[id] = ToDoItemImplementation.parse(json: subjson)
                    } else {
                        return
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
