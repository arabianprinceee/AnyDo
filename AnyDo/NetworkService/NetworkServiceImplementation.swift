//
//  NetworkServiceImplementation.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/4/21.
//

import Foundation

final class NetworkServiceImplementation: NetworkService {

    // MARK: Properties

    private let networkQueue = DispatchQueue(label: "com.AnyDo.NetworkServiceQueue", attributes: [.concurrent])
    private var apiUrl = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net"
    private let apiToken = "LTQwNDc2NDgyNTA0MTEzNDYzNTY"

    // MARK: Methods

    func getToDoItems(completion: @escaping ToDoItemsCompletion) {
        guard let url = URL(string: "\(apiUrl)/tasks") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    completion(.failure(NetworkServiceErrors.networkError))
                    return
                }
                do {
                    let toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
                    completion(.success(toDoItems))
                    return
                } catch {
                    completion(.failure(ParsingErrors.decodingError))
                    return
                }
            }.resume()
        }
    }

    func saveToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion) {
        guard let url = URL(string: "\(apiUrl)/tasks") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        guard let httpBody = try? JSONEncoder().encode(item) else {
            completion(.failure(ParsingErrors.encodingError))
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    completion(.failure(NetworkServiceErrors.networkError))
                    return
                }
                completion(.success(()))
            }.resume()
        }
    }

    func updateToDoItem(item: ToDoItem, completion: @escaping EmptyCompletion) {
        guard let url = URL(string: "\(apiUrl)/tasks/\(item.id)") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        guard let httpBody = try? JSONEncoder().encode(item) else {
            completion(.failure(ParsingErrors.encodingError))
            return
        }
        
        request.httpBody = httpBody

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    completion(.failure(NetworkServiceErrors.networkError))
                    return
                }
                completion(.success(()))
            }.resume()
        }
    }

    func deleteToDoItem(with id: String, completion: @escaping EmptyCompletion) {
        guard let url = URL(string: "\(apiUrl)/tasks/\(id)") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    completion(.failure(NetworkServiceErrors.networkError))
                    return
                }
                completion(.success(()))
            }.resume()
        }
    }

    func synchronizeToDoItems(ids: [String], items: [ToDoItem], completion: @escaping ToDoItemsCompletion) {
        guard let url = URL(string: "\(apiUrl)/tasks") else { return }

        print("Started synchronizing...")

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        var dict: [String: Any] = [:]
        dict["deleted"] = ids
        dict["other"] = items.map({$0.syncronizationJson()})

        guard
            let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []),
            JSONSerialization.isValidJSONObject(dict)
        else {
            completion(.failure(ParsingErrors.encodingError))
            return
        }

        request.httpBody = httpBody

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    completion(.failure(NetworkServiceErrors.networkError))
                    return
                }
                do {
                    let toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
                    completion(.success(toDoItems))
                    return
                } catch {
                    completion(.failure(ParsingErrors.decodingError))
                    return
                }
            }.resume()
        }
    }

}
