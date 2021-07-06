//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties

    var fileCacheManager: FileCacheService
    var networkManager: NetworkService
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
        self.fileCacheManager = fileCacheManager
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        self.fileCacheManager.delegate = self
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
        self.toDoItemsArray = fileCacheManager.toDoItemsData.map { $0.value }.sorted { $0.text < $1.text }
    }

    // MARK: Methods

    private func updateToDoItemsArray() {
        self.toDoItemsArray = fileCacheManager.toDoItemsData.map { $0.value }.sorted { $0.text < $1.text }
    }

    func updateDoneTasksLabel() {
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(self.toDoItemsArray.filter { $0.status == .completed }.count)"
    }
    
    // MARK: Objc methods
    
    @objc func onAddItemButtonTapped() {
        let vc = ToDoViewController(fileCacheManager: self.fileCacheManager, networkManager: self.networkManager, currentToDoItem: nil)
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
        self.tableView.reloadData()
    }
    
}

// MARK: FileCacheDelegate

extension MainViewController: FileCacheServiceDelegate {

    func onArrayDidChange(_ sender: FileCacheServiceImplementation) {
        toDoItemsArray = fileCacheManager.toDoItemsData.map { $0.value }.sorted { $0.text < $1.text }
        DispatchQueue.main.async {
            self.updateDoneTasksLabel()
            self.updateToDoItemsArray()
            self.tableView.reloadData()
        }
    }
    
}
