//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties

    var fileCacheService: FileCacheService
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
    
    init(fileCacheManager: FileCacheService, networkManager: NetworkService) {
        self.fileCacheService = fileCacheManager
        self.networkService = networkManager
        super.init(nibName: nil, bundle: nil)
        self.fileCacheService.delegate = self
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

    override func viewWillAppear(_ animated: Bool) {
        fileCacheService.loadAllTasks(fileName: fileCacheService.cacheFileName) {
            print(self.fileCacheService.toDoItemsData.count)
            print(self.fileCacheService.toDoItemsData.values.filter({$0.isDirty}).count)
            self.fileCacheService.loadAllTombstones {
                print("loaded all tombstones")
                self.networkService.synchronizeToDoItems(ids: self.fileCacheService.tombstonesData.map({$0.id}),
                                                         items: self.fileCacheService.toDoItemsData.values.filter({$0.isDirty == true})) { result in
                    switch result {
                    case .success(let toDoItems):
                        print("Succesfully synchronized data")
                        self.fileCacheService.saveItemsFromServer(items: toDoItems) {
                            print("Successfully saved items from server to local data")
                            self.fileCacheService.deleteAllTombstones()
                            self.fileCacheService.makeAllTasksNotDirty {
                                self.updateToDoItemsArray()
                                DispatchQueue.main.async {
                                    self.updateDoneTasksLabel()
                                    self.tableView.reloadData()
                                }
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
            }
        }
    }

    // MARK: Methods

    private func updateToDoItemsArray() {
        self.toDoItemsArray = fileCacheService.toDoItemsData.map { $0.value }.sorted { $0.text < $1.text }
    }

    func updateDoneTasksLabel() {
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(self.toDoItemsArray.filter { $0.status == .completed }.count)"
    }

    // MARK: Objc methods

    @objc func onAddItemButtonTapped() {
        let vc = ToDoViewController(fileCacheManager: self.fileCacheService, networkManager: self.networkService, currentToDoItem: nil)
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

extension MainViewController: FileCacheServiceDelegate {

    func onArrayDidChange(_ sender: FileCacheServiceImplementation) {
        toDoItemsArray = fileCacheService.toDoItemsData.map { $0.value }.sorted { $0.text < $1.text }
        DispatchQueue.main.async {
            self.updateDoneTasksLabel()
            self.updateToDoItemsArray()
            self.tableView.reloadData()
        }
    }
    
}
