//
//  NetworkService.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/3/21.
//

import Foundation

typealias EmptyResult = Result<Void, Error>
typealias EmptyCompletion = (_ result: EmptyResult) -> Void
typealias ToDoItemsResult = Result<[ToDoItem], Error>
typealias ToDoItemsCompletion = (_ result: ToDoItemsResult) -> Void

protocol NetworkService {

    func getToDoItems(completion: @escaping ToDoItemsCompletion)
    func saveToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion)
    func updateToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion)
    func deleteToDoItem(with id: String, completion: @escaping EmptyCompletion)
    func synchronizeToDoItems(ids: [String], items: [ToDoItem], completion: @escaping ToDoItemsCompletion)
    
}

enum NetworkServiceErrors: Error {

    case networkError

}
