//
//  Extension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/19/21.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeTask = UIContextualAction(style: .normal, title: nil) { (action, sourceView, _) in
            
            let item = ToDoItem(id: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].id,
                                text: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].text,
                                importance: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].importance,
                                deadLine: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].deadline,
                                status: .completed)
            
            self.fileCacheManager.deleteTask(with: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].id, fileName: self.cacheFileName)
            self.fileCacheManager.addToDoItem(toDoItem: item, fileName: self.cacheFileName)
            
            self.updateDoneTasksLabel()
            tableView.reloadData()
        }
        
        completeTask.backgroundColor = .systemGreen
        completeTask.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white)
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [completeTask])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTask = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, _) in
            self.fileCacheManager.deleteTask(with: self.fileCacheManager.toDoItems.map { $0.value }[indexPath.row].id, fileName: self.cacheFileName)
            self.updateDoneTasksLabel()
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        }
        
        deleteTask.backgroundColor = .systemRed
        deleteTask.image = UIImage(systemName: "trash")?.withTintColor(.white)
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteTask])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.fileCacheManager.toDoItems.map { $0.value }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM"
        
        if let deadline = self.fileCacheManager.toDoItems.map({ $0.value })[indexPath.row].deadline {
            print(dateFormatterPrint.string(from: deadline))
            cell.configure(status: fileCacheManager.toDoItems.map { $0.value }[indexPath.row].status, taskName: fileCacheManager.toDoItems.map { $0.value }[indexPath.row].text, deadline: dateFormatterPrint.string(from: deadline))
            return cell
        }
        
        cell.configure(status: fileCacheManager.toDoItems.map { $0.value }[indexPath.row].status, taskName: fileCacheManager.toDoItems.map { $0.value }[indexPath.row].text)
        return cell
    }
    
}
