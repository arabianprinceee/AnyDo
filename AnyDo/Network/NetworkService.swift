//
//  NetworkService.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/3/21.
//

import Foundation

typealias EmptyResult = Result<Void, Error>
typealias ToDoItemResult = Result<ToDoItem, Error>
typealias ToDoItemsResult = Result<[ToDoItem], Error>
typealias EmptyCompletion = (_ result: EmptyResult) -> Void
typealias ToDoItemCompletion = (_ result: ToDoItemResult) -> Void
typealias ToDoItemsCompletion = (_ result: ToDoItemsResult) -> Void

protocol NetworkService {

    func getToDoItems(completion: @escaping ToDoItemsCompletion)
    func saveToDoItem(completion: @escaping EmptyCompletion)
    func updateToDoItem(completion: @escaping EmptyCompletion)
    func deleteToDoItem(completion: @escaping EmptyCompletion)
//    func synchronizeToDoItems()

}
