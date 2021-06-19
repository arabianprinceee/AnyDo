//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties
    
    var myTasks: [ToDoItem] = [ToDoItem(text: "Задача 1", importance: .important, deadLine: nil, status: .uncompleted),
                               ToDoItem(text: "Задача 2", importance: .standart, deadLine: Date(), status: .uncompletedImportant),
                               ToDoItem(text: "Задача 2", importance: .standart, deadLine: Date(), status: .completed)]
    
    var doneTasksQuantity: Int = 0
    let addItemButton = UIButton()
    let viewTitle = UILabel()
    let doneTasksLabel = UILabel()
    let showHideTasksButton = UIButton()
    
    let cellIdentifier = String(describing: TableViewCell.self)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        return tableView
    }()
    
    
    // MARK: Enums
    
    enum DesignConstants {
        static var titleTopConstraint: CGFloat { return 60 }
        static var titleLeftConstraint: CGFloat { return 32 }
        static var doneTasksToTitleConstraint: CGFloat { return 18 }
        static var addItemButtonFrames: CGFloat { return 44 }
        static var addItemButtonBottomConstraint: CGFloat { return -54 }
        static var showHideButtonRightConstraing: CGFloat { return -32 }
    }
    
    enum FontSizes {
        static var title: CGFloat { return 34 }
        static var underTitleLabels: CGFloat { return 15 }
    }
    
    
    // MARK: System methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    // MARK: Private methods
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: doneTasksLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpViewTitle() {
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.text = NSLocalizedString("mainTitle", comment: "")
        viewTitle.font = .boldSystemFont(ofSize: FontSizes.title)
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: DesignConstants.titleTopConstraint),
            viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }
    
    private func setUpDoneTasksLabel() {
        doneTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(myTasks.filter { $0.status == .completed }.count)"
        doneTasksLabel.font = .systemFont(ofSize: FontSizes.underTitleLabels)
        doneTasksLabel.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            doneTasksLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: DesignConstants.doneTasksToTitleConstraint),
            doneTasksLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }
    
    private func setUpShowHideButton() {
        showHideTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
        showHideTasksButton.setTitleColor(.systemBlue, for: .normal)
        showHideTasksButton.titleLabel?.font = .boldSystemFont(ofSize: FontSizes.underTitleLabels)
        showHideTasksButton.addTarget(self, action: #selector(showHideTasksButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showHideTasksButton.centerYAnchor.constraint(equalTo: doneTasksLabel.centerYAnchor),
            showHideTasksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: DesignConstants.showHideButtonRightConstraing)
        ])
    }
    
    private func setUpAddButton() {
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = UIColor(named: "AddButtonColor")
        addItemButton.layer.cornerRadius = DesignConstants.addItemButtonFrames / 2
        
        addItemButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addItemButton.imageView?.tintColor = UIColor.white
        addItemButton.imageView?.contentMode = .scaleToFill
        
        addItemButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DesignConstants.addItemButtonBottomConstraint),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames),
            addItemButton.heightAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames)
        ])
    }
    
    
    // MARK: Objc methods
    
    @objc private func addItemButtonTapped() {
        let vc = ToDoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func showHideTasksButtonTapped() {
        if showHideTasksButton.titleLabel?.text == NSLocalizedString("show", comment: "") {
            showHideTasksButton.setTitle(NSLocalizedString("hide", comment: ""), for: .normal)
            
            // TODO
        
        } else {
            showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
            
            // TODO
            
        }
    }
    
}
