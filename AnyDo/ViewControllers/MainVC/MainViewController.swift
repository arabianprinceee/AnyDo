//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties
    
    var fileCacheManager: FileCache
    let cellIdentifier = String(describing: TableViewCell.self)
    let completedTasksCondition: CompletedTasksCondition = .showCompleted
    var toDoItemsArray: [ToDoItem]
    
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
    
    init(fileCacheManager: FileCache) {
        self.fileCacheManager = fileCacheManager
        self.toDoItemsArray = fileCacheManager.toDoItems.map { $0.value }.sorted { $0.text < $1.text }
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

    // MARK: Methods

    private func updateToDoItemsArray() {
        self.toDoItemsArray = fileCacheManager.toDoItems.map { $0.value }.sorted { $0.text < $1.text }
    }

    func updateDoneTasksLabel() {
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(self.toDoItemsArray.filter { $0.status == .completed }.count)"
    }
    
    // MARK: Objc methods
    
    @objc func onAddItemButtonTapped() {
        let vc = ToDoViewController(fileCacheManager: self.fileCacheManager, currentToDoItem: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onShowHideTasksButtonTapped() {
        switch completedTasksCondition {
        case .hideCompleted:
            showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
            toDoItemsArray = toDoItemsArray.filter { $0.status != .completed }
        case .showCompleted:
            showHideTasksButton.setTitle(NSLocalizedString("hide", comment: ""), for: .normal)
            updateToDoItemsArray()
        }
        updateDoneTasksLabel()
        tableView.reloadData()
    }
    
    @objc private func onToDoVCDismissed() {
        updateToDoItemsArray()
        self.tableView.reloadData()
    }
    
}

// MARK: FileCacheDelegate

extension MainViewController: FileCacheDelegate {
    
    func arrayDidChange(_ sender: FileCacheImplementation) {
        updateDoneTasksLabel()
        updateToDoItemsArray()
        tableView.reloadData()
    }
    
}
