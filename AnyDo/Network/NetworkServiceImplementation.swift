//
//  NetworkServiceImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/4/21.
//

import Foundation

final class NetworkServiceImplementation: NetworkService {

    private let networkQueue = DispatchQueue(label: "com.AnyDo.NetworkServiceQueue", attributes: [.concurrent])

    func getToDoItems(completion: @escaping ToDoItemsCompletion) {
        
    }

    func saveToDoItem(completion: @escaping EmptyCompletion) {

    }

    func updateToDoItem(completion: @escaping EmptyCompletion) {

    }

    func deleteToDoItem(completion: @escaping EmptyCompletion) {
        
    }

}
