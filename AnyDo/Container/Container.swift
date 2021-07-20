//
//  Container.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 7/20/21.
//

import Foundation

protocol Container {
    static func getMainVC() -> MainViewController
}

class ContainerImplementation: Container {
    static func getMainVC() -> MainViewController {
        let storageService = StorageServiceImplementation(dataBaseFileName: "AnyDoDataBase")
        let networkService = NetworkServiceImplementation()
        return MainViewController(storageService: storageService, networkService: networkService)
    }
}
