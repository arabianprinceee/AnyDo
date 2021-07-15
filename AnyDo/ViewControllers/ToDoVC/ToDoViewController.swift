//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

class ToDoViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties

    private let storageService: StorageService
    private let networkService: NetworkService
    var currentToDoItem: ToDoItem?
    var isEditingItem: Bool = false
    
    let dateOfTask: UILabel = UILabel()
    let calendarSwitch: UISwitch = UISwitch()
    let taskPrioritySementedControl: UISegmentedControl = UISegmentedControl(items: [" ↘️ "," ➡️ "," ↗️ "])
    let taskTextView: UITextView = UITextView()
    var calendarDivider: UIView?
    let datePickerView: UIDatePicker = UIDatePicker()
    let taskOptionsView: UIStackView = UIStackView()
    let taskDescriptionView: UIView = UIView()
    let deleteButtonView: UIButton = UIButton()
    var navigationBar: UINavigationBar = UINavigationBar()
    
    lazy var scrollView : UIScrollView = {
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

        setupEditScreen()

        // Чтобы прятать клавиатуру
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Methods

    private func setupEditScreen() {
        if currentToDoItem != nil {
            self.isEditingItem = true
            self.taskTextView.text = currentToDoItem?.text

            switch currentToDoItem?.importance {
            case .unimportant:
                self.taskPrioritySementedControl.selectedSegmentIndex = 0
            case .standart:
                self.taskPrioritySementedControl.selectedSegmentIndex = 1
            case .important:
                self.taskPrioritySementedControl.selectedSegmentIndex = 2
            case .none:
                self.taskPrioritySementedControl.selectedSegmentIndex = 1
            }

            if let deadline = currentToDoItem?.deadline {
                self.calendarSwitch.isOn = true
                self.configureCalendar(for: deadline)
                self.datePickerView.date = deadline
            }
        }
    }
    
    private func getStringFromDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        return df.string(from: datePickerView.date)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // MARK: Objc methods
    
    @objc func onSwitchChanged(sender: UISwitch) {
        if (sender.isOn) {
            configureCalendar(for: Date())
            dateOfTask.textColor = .systemBlue
            dateOfTask.font = .boldSystemFont(ofSize: 13)
            dateOfTask.text = getStringFromDate()
        } else {
            dateOfTask.text = ""
            datePickerView.removeFromSuperview()
            calendarDivider?.removeFromSuperview()
            taskOptionsView.layoutIfNeeded()
        }
    }
    
    @objc func onDeleteButtonTapped(sender: UIButton) {
        if isEditingItem,
           let id = currentToDoItem?.id {
            self.storageService.deleteToDoItem(with: id)
            NotificationCenter.default.post(name: .toDoListChanged, object: nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Nothing to delete", comment: ""),
                                          message: NSLocalizedString("Create before delete", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func onHandleDateChanges(sender: UIDatePicker) {
        dateOfTask.textColor = .systemBlue
        dateOfTask.font = .boldSystemFont(ofSize: 13)
        dateOfTask.text = getStringFromDate()
    }
    
    @objc func onDismissVC() {
        if let text = taskTextView.text, text != "", text != NSLocalizedString("enterTaskName", comment: "") {
            switch isEditingItem {
            case true:
                guard let currentToDoItem = currentToDoItem else { return }
                let index = taskPrioritySementedControl.selectedSegmentIndex
                let task = ToDoItem(id: currentToDoItem.id,
                                    text: self.taskTextView.text,
                                    importance: index == 0 ? .unimportant : index == 1 ? .standart : .important,
                                    deadLine: calendarSwitch.isOn ? datePickerView.date : nil,
                                    status: currentToDoItem.status == .completed ? .completed : index == 2 ? .uncompletedImportant : .uncompleted,
                                    createdAt: currentToDoItem.createdAt,
                                    updatedAt: Int(Date().timeIntervalSince1970))

                self.storageService.updateToDoItem(todoItem: task)

                self.networkService.updateToDoItem(item: task) { result in
                    switch result {
                    case .success():
                        print("Successfully updated toDoItem")
                    case .failure(_):
                        print("Error during updating toDoItem")
                        let dirtyTask = ToDoItem(id: currentToDoItem.id,
                                                 text: task.text,
                                                 importance: task.importance,
                                                 deadLine: task.deadline,
                                                 status: task.status == .completed ? .completed : index == 2 ? .uncompletedImportant : .uncompleted,
                                                 createdAt: task.createdAt,
                                                 updatedAt: task.updatedAt,
                                                 isDirty: true)

                        self.storageService.updateToDoItem(todoItem: dirtyTask)
                        print("Dirty task has been created")
                    }
                    NotificationCenter.default.post(name: .toDoListChanged, object: nil)
                }
            case false:
                let id = UUID().uuidString
                let index = taskPrioritySementedControl.selectedSegmentIndex
                let task = ToDoItem(id: id,
                                    text: self.taskTextView.text,
                                    importance: index == 0 ? .unimportant : index == 1 ? .standart : .important,
                                    deadLine: calendarSwitch.isOn ? datePickerView.date : nil,
                                    status: index == 2 ? .uncompletedImportant : .uncompleted,
                                    createdAt: Int(Date().timeIntervalSince1970),
                                    updatedAt: nil,
                                    isDirty: false)

                self.storageService.addToDoItem(toDoItem: task)

                self.networkService.saveToDoItem(item: task) { result in
                    switch result {
                    case .success():
                        print("Successfully saved ToDoItem")
                    case .failure(_):
                        print("Error during saving new task")
                        let dirtyTask = ToDoItem(id: task.id,
                                                 text: task.text,
                                                 importance: task.importance,
                                                 deadLine: task.deadline,
                                                 status: task.status,
                                                 createdAt: task.createdAt,
                                                 isDirty: true)

                        self.storageService.updateToDoItem(todoItem: dirtyTask)
                        print("Dirty task has been saved")
                    }
                    NotificationCenter.default.post(name: .toDoListChanged, object: nil)
                }
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

}
