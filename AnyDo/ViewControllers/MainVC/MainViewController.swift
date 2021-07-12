//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties

    var storageService: StorageService
    var networkService: NetworkService
    let cellIdentifier = String(describing: TableViewCell.self)
    var completedTasksCondition: CompletedTasksCondition = .showCompleted
    var toDoItemsArray: [ToDoItem] = []
    
    let addItemButton = UIButton()
    let viewTitle = UILabel()
    let doneTasksLabel = UILabel()
    let showHideTasksButton = UIButton()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        return tableView
    }()
    
    // MARK: Initialization && Deinitialization
    
    init(storageService: StorageService, networkService: NetworkService) {
        self.storageService = storageService
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
        self.storageService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: System methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onToDoVCDismissed), name: .toDoListChanged, object: nil)
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(viewTitle)
        view.addSubview(doneTasksLabel)
        view.addSubview(showHideTasksButton)
        view.addSubview(tableView)
        view.addSubview(addItemButton)
        
        setUpViewTitle()
        setUpDoneTasksLabel()
        setUpShowHideButton()
        setUpTableView()
        setUpAddButton()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        storageService.loadAllToDoItems { loadToDoItemsResult in
//            switch loadToDoItemsResult {
//            case .success():
//                print("willapeear:\n")
//                print(self.storageService.toDoItemsData)
//                self.storageService.addToDoItem(toDoItem: ToDoItem(text: "1", importance: .important, deadLine: nil, status: .completed))
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }

        override func viewWillAppear(_ animated: Bool) {
            storageService.loadAllToDoItems { loadToDoItemsResult in
                switch loadToDoItemsResult {
                case .success():
                    print("\n\nElements:")
                    for elem in self.storageService.toDoItemsData {
                        print("\n\(elem)")
                    }
                    print("\n\n")
                    self.storageService.loadAllTombstones { loadTombstonesResult in
                        switch loadTombstonesResult {
                        case .success():
                            print("loaded all tombstones")
                            self.networkService.synchronizeToDoItems(ids: self.storageService.tombstonesData.map({$0.id}),
                                                                     items: self.storageService.toDoItemsData.filter({$0.isDirty == true})) { synchronizeResult in
                                switch synchronizeResult {
                                case .success(let toDoItems):
                                    print("Succesfully synchronized data")

                                    print("\n\nElements from server:")
                                    for elem in toDoItems {
                                        print("\n\(elem)")
                                    }
                                    print("\n\n")
                                    self.storageService.saveToDoItemsFromServer(items: toDoItems) { saveItemsResult in
                                        switch saveItemsResult {
                                        case .success():
                                            print("Successfully saved items from server to local data")
                                            print("\n\nElements after saving from server:")
                                            for elem in self.storageService.toDoItemsData {
                                                print("\n\(elem)")
                                            }
                                            print("\n\n")
                                            self.storageService.deleteAllTombstones()
                                            self.storageService.makeAllToDoItemsNotDirty { makeNotDirtyResult in
                                                switch makeNotDirtyResult {
                                                case .success():
                                                    print("\n\nElements after making not dirty:")
                                                    for elem in self.storageService.toDoItemsData {
                                                        print("\n\(elem)")
                                                    }
                                                    print("\n\n")
                                                    self.updateToDoItemsArray()
                                                    DispatchQueue.main.async {
                                                        self.updateDoneTasksLabel()
                                                        self.tableView.reloadData()
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                case .failure(_):
                                    print("Synchronize error happend")
                                    self.updateToDoItemsArray()
                                    DispatchQueue.main.async {
                                        self.updateDoneTasksLabel()
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

    // MARK: Methods

    private func updateToDoItemsArray() {
        self.toDoItemsArray = storageService.toDoItemsData.sorted { $0.text < $1.text }
    }

    func updateDoneTasksLabel() {
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(self.toDoItemsArray.filter { $0.status == .completed }.count)"
    }

    // MARK: Objc methods

    @objc func onAddItemButtonTapped() {
        let vc = ToDoViewController(storageService: self.storageService, networkService: self.networkService, currentToDoItem: nil)
        self.present(vc, animated: true, completion: nil)
    }

    @objc func onShowHideTasksButtonTapped() {
        switch completedTasksCondition {
        case .showCompleted:
            showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
            toDoItemsArray = toDoItemsArray.filter { $0.status != .completed }
        case .hideCompleted:
            showHideTasksButton.setTitle(NSLocalizedString("hide", comment: ""), for: .normal)
            updateToDoItemsArray()
        }
        completedTasksCondition = completedTasksCondition == .hideCompleted ? .showCompleted : .hideCompleted
        updateDoneTasksLabel()
        tableView.reloadData()
    }

    @objc private func onToDoVCDismissed() {
        updateToDoItemsArray()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

// MARK: FileCacheDelegate

extension MainViewController: StorageServiceDelegate {

    func storageServiceOnArrayDidChange(_ sender: StorageServiceImplementation) {
        toDoItemsArray = storageService.toDoItemsData.sorted { $0.text < $1.text }
        DispatchQueue.main.async {
            self.updateDoneTasksLabel()
            self.updateToDoItemsArray()
            self.tableView.reloadData()
        }
    }
    
}
