//
//  ToDoPresenter.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/19/21.
//

import Foundation

protocol ToDoPresenter: AnyObject {

    var currentToDoItem: ToDoItem? { get }
    var isEditing: Bool { get }

    init(view: ToDoView, currentToDoItem: ToDoItem?)
    
    func setupEditScreen()
    func deleteToDoItem(storageService: StorageService,
                        networkService: NetworkService)
    func updateToDoItem(id: String,
                      text: String,
                      importance: Importance,
                      deadline: Date?,
                      status: TaskStatus,
                      createdAt: Int,
                      updatedAt: Int?,
                      storageService: StorageService,
                      networkService: NetworkService)
    func saveToDoItem(id: String,
                      text: String,
                      importance: Importance,
                      deadline: Date?,
                      status: TaskStatus,
                      createdAt: Int,
                      updatedAt: Int?,
                      storageService: StorageService,
                      networkService: NetworkService)

}

class ToDoPresenterImplementation: ToDoPresenter {

    private weak var view: ToDoView?
    var isEditing: Bool
    var currentToDoItem: ToDoItem?

    required init(view: ToDoView, currentToDoItem: ToDoItem?) {
        self.view = view
        self.currentToDoItem = currentToDoItem
        if let _ = currentToDoItem {
            self.isEditing = true
        } else {
            self.isEditing = false
        }
    }

    func setupEditScreen() {
        if let currentToDoItem = self.currentToDoItem {
            let text = currentToDoItem.text

            let index: Int
            switch currentToDoItem.importance {
            case .unimportant:
                index = 0
            case .standart:
                index = 1
            case .important:
                index = 2
            }

            if let deadline = currentToDoItem.deadline {
                view?.onReceivedScreenSetupInfo(text: text, index: index, deadline: deadline)
            } else {
                view?.onReceivedScreenSetupInfo(text: text, index: index, deadline: nil)
            }
        }
    }

    func deleteToDoItem(storageService: StorageService, networkService: NetworkService) {
        if isEditing,
           let id = currentToDoItem?.id {
            storageService.deleteToDoItem(with: id)
            networkService.deleteToDoItem(with: id) { result in
                switch result {
                case .success():
                    print("Item has been successfully deleted from server")
                case .failure(_):
                    storageService.addTombstone(tombstone: Tombstone(id: id, deletedAt: Date()))
                    print("Tombstone has been created")
                }
            }
            view?.onToDoItemDeleted(success: true)
            return
        }
        view?.onToDoItemDeleted(success: false)
    }

    func updateToDoItem(id: String,
                      text: String,
                      importance: Importance,
                      deadline: Date?,
                      status: TaskStatus,
                      createdAt: Int,
                      updatedAt: Int?,
                      storageService: StorageService,
                      networkService: NetworkService) {
        let task = ToDoItem(id: id,
                            text: text,
                            importance: importance,
                            deadline: deadline,
                            status: status,
                            createdAt: createdAt,
                            updatedAt: updatedAt,
                            isDirty: false)

        storageService.updateToDoItem(todoItem: task)

        networkService.updateToDoItem(item: task) { result in
            switch result {
            case .success():
                print("Successfully updated toDoItem")
            case .failure(_):
                print("Error during updating toDoItem")
                let dirtyTask = ToDoItem(id: task.id,
                                         text: task.text,
                                         importance: task.importance,
                                         deadline: task.deadline,
                                         status: task.status,
                                         createdAt: task.createdAt,
                                         updatedAt: task.updatedAt,
                                         isDirty: true)

                storageService.updateToDoItem(todoItem: dirtyTask)
                print("Dirty task has been created")
            }
        }

        view?.onToDoItemSavedOrUpdated()
    }

    func saveToDoItem(id: String,
                      text: String,
                      importance: Importance,
                      deadline: Date?,
                      status: TaskStatus,
                      createdAt: Int,
                      updatedAt: Int?,
                      storageService: StorageService,
                      networkService: NetworkService) {
        let task = ToDoItem(id: id,
                            text: text,
                            importance: importance,
                            deadline: deadline,
                            status: status,
                            createdAt: createdAt,
                            updatedAt: updatedAt,
                            isDirty: false)

        storageService.addToDoItem(toDoItem: task)

        networkService.saveToDoItem(item: task) { result in
            switch result {
            case .success():
                print("Successfully saved ToDoItem")
            case .failure(_):
                print("Error during saving new task")
                let dirtyTask = ToDoItem(id: task.id,
                                         text: task.text,
                                         importance: task.importance,
                                         deadline: task.deadline,
                                         status: task.status,
                                         createdAt: task.createdAt,
                                         isDirty: true)

                storageService.updateToDoItem(todoItem: dirtyTask)
                print("Dirty task has been saved")
            }
        }

        view?.onToDoItemSavedOrUpdated()
    }
    
}
