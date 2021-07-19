//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

protocol ToDoView: AnyObject {
    func onReceivedScreenSetupInfo(text: String, index: Int, deadline: Date?)
    func onToDoItemDeleted(success: Bool)
    func onToDoItemSavedOrUpdated()
}

class ToDoViewController: UIViewController {

    // MARK: Properties

    private let storageService: StorageService
    private let networkService: NetworkService

    private let currentToDoItem: ToDoItem?
    private var isEditingItem: Bool = false

    private var presenter: ToDoPresenter!
    
    let dateOfTask: UILabel = UILabel()
    let calendarSwitch: UISwitch = UISwitch()
    let taskPrioritySementedControl: UISegmentedControl = UISegmentedControl(items: [" ↘️ "," ➡️ "," ↗️ "])
    let taskTextView: UITextView = UITextView()
    let datePickerView: UIDatePicker = UIDatePicker()
    let taskOptionsView: UIStackView = UIStackView()
    let taskDescriptionView: UIView = UIView()
    let deleteButtonView: UIButton = UIButton()
    var calendarDivider: UIView?
    var navigationBar: UINavigationBar = UINavigationBar()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.insetsLayoutMarginsFromSafeArea = true
        view.contentInsetAdjustmentBehavior = .always
        view.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Initialization
    
    init(storageService: StorageService, networkService: NetworkService, currentToDoItem: ToDoItem?) {
        self.storageService = storageService
        self.networkService = networkService
        self.currentToDoItem = currentToDoItem
        super.init(nibName: nil, bundle: nil)
        presenter = ToDoPresenterImplementation(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: System methods
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setUpNavigationBar()
        
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(taskDescriptionView)
        scrollView.addSubview(taskOptionsView)
        scrollView.addSubview(deleteButtonView)
        setUpTaskDescriptionView()
        setUpTaskOptionsView()
        setUpDeleteButtonView()

        deleteButtonView.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
        calendarSwitch.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
        datePickerView.addTarget(self, action: #selector(onHandleDateChanges), for: .valueChanged)

        isEditingItem = presenter.setupEditScreen(item: currentToDoItem)

        // Чтобы прятать клавиатуру
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Objc methods
    
    @objc func onSwitchChanged(sender: UISwitch) {
        switch sender.isOn {
        case true:
            configureCalendar(for: Date())
            dateOfTask.textColor = .systemBlue
            dateOfTask.font = .boldSystemFont(ofSize: 13)
            dateOfTask.text = getStringFromDate()
        case false:
            dateOfTask.text = ""
            datePickerView.removeFromSuperview()
            calendarDivider?.removeFromSuperview()
            taskOptionsView.layoutIfNeeded()
        }
    }
    
    @objc func onDeleteButtonTapped(sender: UIButton) {
        presenter.deleteToDoItem(isEditingItem: isEditingItem, item: currentToDoItem, storageService: storageService, networkService: networkService)
    }
    
    @objc func onHandleDateChanges(sender: UIDatePicker) {
        dateOfTask.textColor = .systemBlue
        dateOfTask.font = .boldSystemFont(ofSize: 13)
        dateOfTask.text = getStringFromDate()
    }
    
    @objc func onDismissVC() {
        if let text = taskTextView.text,
           text != "",
           text != NSLocalizedString("enterTaskName", comment: "") {
            switch isEditingItem {
            case true:
                guard let currentToDoItem = currentToDoItem else { return }
                let index = taskPrioritySementedControl.selectedSegmentIndex
                presenter.updateToDoItem(id: currentToDoItem.id,
                                       text: self.taskTextView.text,
                                       importance: index == 0 ? .unimportant : index == 1 ? .standart : .important,
                                       deadline: calendarSwitch.isOn ? datePickerView.date : nil,
                                       status: currentToDoItem.status == .completed ? .completed : index == 2 ? .uncompletedImportant : .uncompleted,
                                       createdAt: currentToDoItem.createdAt,
                                       updatedAt: Int(Date().timeIntervalSince1970),
                                       storageService: storageService,
                                       networkService: networkService)
            case false:
                let id = UUID().uuidString
                let index = taskPrioritySementedControl.selectedSegmentIndex
                presenter.saveToDoItem(id: id,
                                         text: self.taskTextView.text,
                                         importance: index == 0 ? .unimportant : index == 1 ? .standart : .important,
                                         deadline: calendarSwitch.isOn ? datePickerView.date : nil,
                                         status: index == 2 ? .uncompletedImportant : .uncompleted,
                                         createdAt: Int(Date().timeIntervalSince1970),
                                         updatedAt: nil,
                                         storageService: storageService,
                                         networkService: networkService)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        if taskTextView.text == "" {
            taskTextView.text = NSLocalizedString("enterTaskName", comment: "")
            taskTextView.textColor = UIColor.lightGray
        }
    }

    // MARK: Private methods

    private func getStringFromDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        return df.string(from: datePickerView.date)
    }

}

extension ToDoViewController: ToDoView {

    func onToDoItemDeleted(success: Bool) {
        switch success {
        case true:
            NotificationCenter.default.post(name: .toDoListChanged, object: nil)
            self.dismiss(animated: true, completion: nil)
        case false:
            let alert = UIAlertController(title: NSLocalizedString("Nothing to delete", comment: ""),
                                          message: NSLocalizedString("Create before delete", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func onReceivedScreenSetupInfo(text: String, index: Int, deadline: Date?) {
        taskTextView.text = text
        taskPrioritySementedControl.selectedSegmentIndex = index
        if let deadline = deadline {
            calendarSwitch.isOn = true
            configureCalendar(for: deadline)
        }
    }

    func onToDoItemSavedOrUpdated() {
        NotificationCenter.default.post(name: .toDoListChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
