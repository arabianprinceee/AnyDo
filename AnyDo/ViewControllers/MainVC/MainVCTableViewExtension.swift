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
        if indexPath.row != self.tableView.numberOfRows(inSection: 0) - 1 && self.toDoItemsArray[indexPath.row].status != .completed {
            let completeTask = UIContextualAction(style: .normal, title: nil) { (action, sourceView, _) in

                let id = self.toDoItemsArray[indexPath.row].id
                let updItem = ToDoItem(id: id,
                                       text: self.toDoItemsArray[indexPath.row].text,
                                       importance: self.toDoItemsArray[indexPath.row].importance,
                                       deadLine: self.toDoItemsArray[indexPath.row].deadline,
                                       status: .completed,
                                       createdAt: self.toDoItemsArray[indexPath.row].createdAt,
                                       updatedAt: Int(Date().timeIntervalSince1970))

                self.storageService.updateToDoItem(todoItem: updItem)

                self.networkService.updateToDoItem(item: updItem) { result in
                    switch result {
                    case .success():
                        print("Successfully updated task on server")
                    case .failure(let error):
                        print(error)
                        print("Error during update task on server")
                        let dirtyTask = ToDoItem(id: id,
                                                 text: updItem.text,
                                                 importance: updItem.importance,
                                                 deadLine: updItem.deadline,
                                                 status: .completed,
                                                 createdAt: updItem.createdAt,
                                                 updatedAt: updItem.updatedAt,
                                                 isDirty: true)

                        self.storageService.updateToDoItem(todoItem: dirtyTask)
                        print("Dirty task has been added")
                    }
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
                self.storageService.deleteToDoItem(with: id)

                self.networkService.deleteToDoItem(with: id) { result in
                    switch result {
                    case .success():
                        print("Item has been successfully deleted from server")
                    case .failure(_):
                        self.storageService.addTombstone(tombstone: Tombstone(id: id, deletedAt: Date()))
                        print("Tombstone has been created")
                    }
                }
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
        self.toDoItemsArray.count + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.tableView.numberOfRows(inSection: 0) - 1 {
            present(ToDoViewController(storageService: self.storageService, networkService: self.networkService, currentToDoItem: toDoItemsArray[indexPath.row]), animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identifier, for: indexPath) as! AddItemCell
            cell.onTaskAdded = { text in
                let id = UUID().uuidString
                let task = ToDoItem(id: id,
                                    text: text,
                                    importance: .standart,
                                    deadLine: nil,
                                    status: .uncompleted,
                                    createdAt: Int(Date().timeIntervalSince1970))

                self.storageService.addToDoItem(toDoItem: task)

                self.networkService.saveToDoItem(item: task) { result in
                    switch result {
                    case .success():
                        print("Successfully saved ToDoItem on server")
                    case .failure(_):
                        print("Error during saving ToDoItem on server")
                        let dirtyTask = ToDoItem(id: task.id,
                                                 text: task.text,
                                                 importance: task.importance,
                                                 deadLine: task.deadline,
                                                 status: task.status,
                                                 createdAt: task.createdAt,
                                                 isDirty: true)

                        self.storageService.updateToDoItem(todoItem: dirtyTask)
                        print("Dirty task has been created")
                    }
                }
            }
            return cell
        } else {
            return configureToDoItemCell(at: indexPath, cell: tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell)
        }
    }

    // MARK: Cell configuration

    private func configureToDoItemCell(at indexPath: IndexPath, cell: TableViewCell) -> TableViewCell {
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

// MARK: Notification center

extension Notification.Name {
    static let toDoListChanged = Notification.Name("ToDoListChanged")
    static let addedToDoFromAddItemCell = Notification.Name("addedToDoFromAddItemCell")
}
