//
//  NetworkServiceImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/4/21.
//

import Foundation

final class NetworkServiceImplementation: NetworkService {

    private let networkQueue = DispatchQueue(label: "com.AnyDo.NetworkServiceQueue", attributes: [.concurrent])
    private var apiUrl = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net"
    private let apiToken = "LTQwNDc2NDgyNTA0MTEzNDYzNTY"

    func getToDoItems(completion: @escaping ToDoItemsCompletion) {
        guard let url = URL(string: apiUrl) else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    if let error = NetworkServiceErrors(rawValue: response.statusCode) {
                        completion(.failure(error))
                    }
                }

                guard let data = data else { return }

                do {
                    let toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
                    completion(.success(toDoItems))
                } catch {
                    print(error.localizedDescription)

                }
            }.resume()
        }
    }

    func saveToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion) {
        
    }

    func updateToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion) {

    }

    func deleteToDoItem(with id: String, completion: @escaping EmptyCompletion) {

    }

}
