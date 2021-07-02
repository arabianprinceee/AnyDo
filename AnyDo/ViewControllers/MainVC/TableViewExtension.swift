//
//  Extension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/19/21.
//

import UIKit

// MARK: UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: Swipe actions

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != self.tableView.numberOfRows(inSection: 0) - 1 {
            let completeTask = UIContextualAction(style: .normal, title: nil) { (action, sourceView, _) in
                if self.toDoItemsArray[indexPath.row].status != .completed {
                    let task = ToDoItem(id: self.toDoItemsArray[indexPath.row].id,
                                        text: self.toDoItemsArray[indexPath.row].text,
                                        importance: self.toDoItemsArray[indexPath.row].importance,
                                        deadLine: self.toDoItemsArray[indexPath.row].deadline,
                                        status: .completed)

                    self.toDoItemsArray.insert(task, at: indexPath.row + 1)
                    self.toDoItemsArray.remove(at: indexPath.row)
                    self.fileCacheManager.deleteTask(with: task.id)
                    self.fileCacheManager.addToDoItem(toDoItem: task)
                }
                else {
                    let alert = UIAlertController(title: NSLocalizedString("already done", comment: ""),
                                                  message: NSLocalizedString("task is done", comment: ""),
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }

            completeTask.backgroundColor = .systemGreen
            completeTask.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white)

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [completeTask])
            swipeActionConfig.performsFirstActionWithFullSwipe = true
            return swipeActionConfig
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != self.tableView.numberOfRows(inSection: 0) - 1 {
            let deleteTask = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, _) in
                let id = self.toDoItemsArray[indexPath.row].id
                self.toDoItemsArray.remove(at: indexPath.row)
                self.fileCacheManager.deleteTask(with: id)
            }

            deleteTask.backgroundColor = .systemRed
            deleteTask.image = UIImage(systemName: "trash")?.withTintColor(.white)

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteTask])
            swipeActionConfig.performsFirstActionWithFullSwipe = true
            return swipeActionConfig
        }
        return nil
    }

    // MARK: Working with cells

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.toDoItemsArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.tableView.numberOfRows(inSection: 0) - 1 {
            present(ToDoViewController(fileCacheManager: fileCacheManager, currentToDoItem: toDoItemsArray[indexPath.row]), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identifier, for: indexPath) as! AddItemCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM"

            if let deadline = self.toDoItemsArray[indexPath.row].deadline {
                cell.configure(status: self.toDoItemsArray[indexPath.row].status,
                               taskName: self.toDoItemsArray[indexPath.row].text,
                               deadline: dateFormatterPrint.string(from: deadline))
                return cell
            }

            cell.configure(status: self.toDoItemsArray[indexPath.row].status,
                           taskName: self.toDoItemsArray[indexPath.row].text)
            return cell
        }
    }
    
}

// MARK: Notification center

extension Notification.Name {
    static let toDoListChanged = Notification.Name("ToDoListChanged")
    static let addedToDoFromAddItemCell = Notification.Name("addedToDoFromAddItemCell")
}
