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
        guard let url = URL(string: "\(apiUrl)/tasks") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(self.detectErrorType(statusCode: response.statusCode)))
                        return
                    }
                    completion(.failure(NetworkServiceErrors.undefinedError))
                    return
                }
                guard let data = data else { return }
                do {
                    let toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
                    completion(.success(toDoItems))
                    return
                } catch {
                    print(error.localizedDescription)

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

        guard let httpBody = try? JSONEncoder().encode(item) else { print("error during encoding"); return }
        request.httpBody = httpBody

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(self.detectErrorType(statusCode: response.statusCode)))
                        return
                    }
                    completion(.failure(NetworkServiceErrors.undefinedError))
                    return
                }
                completion(.success(()))
                return
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

        guard let httpBody = try? JSONEncoder().encode(item) else { print("error during encoding"); return }
        request.httpBody = httpBody

        let session = URLSession.shared
        networkQueue.async {
            session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(self.detectErrorType(statusCode: response.statusCode)))
                        return
                    }
                    completion(.failure(NetworkServiceErrors.undefinedError))
                    return
                }
                completion(.success(()))
                return
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
                if let _ = error {
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(self.detectErrorType(statusCode: response.statusCode)))
                        return
                    }
                    completion(.failure(NetworkServiceErrors.undefinedError))
                    return
                }
                completion(.success(()))
                return
            }.resume()
        }
    }

    // TODO: synchronize local items with server
    func synchronizeToDoItems() {

    }

    private func detectErrorType(statusCode: Int) -> NetworkServiceErrors {
        switch statusCode {
        case 403:
            return .invalidToken
        case 404:
            return .incorrectUrlOrToDoItem
        case 415:
            return .wrongContentType
        case 500:
            return .serverError
        default:
            return .undefinedError
        }
    }

}
