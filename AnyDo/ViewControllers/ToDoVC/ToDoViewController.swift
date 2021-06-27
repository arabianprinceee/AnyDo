//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

class ToDoViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties

    private let fileCacheManager: FileCacheImplementation
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
        view.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 450)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Initialization
    
    init(fileCacheManager: FileCacheImplementation, currentToDoItem: ToDoItem?) {
        self.fileCacheManager = fileCacheManager
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

        deleteButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        calendarSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        datePickerView.addTarget(self, action: #selector(handlingDateChanges), for: .valueChanged)

        setupEditScreen()
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
    
    @objc func switchChanged(sender: UISwitch) {
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
    
    @objc func buttonTapped(sender: UIButton) {
        if (isEditingItem) {
            self.fileCacheManager.deleteTask(with: currentToDoItem!.id) // Вообще, форс - плохо, но в данной ситуации мы проверяли, что currentToDoItem не nil
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
    
    @objc func handlingDateChanges(sender: UIDatePicker) {
        dateOfTask.textColor = .systemBlue
        dateOfTask.font = .boldSystemFont(ofSize: 13)
        dateOfTask.text = getStringFromDate()
    }
    
    @objc func dismissVC() {

        if (isEditingItem) {
            self.fileCacheManager.deleteTask(with: currentToDoItem!.id) // Вообще, форс - плохо, но в данной ситуации мы проверяли, что currentToDoItem не nil
            self.fileCacheManager.addToDoItem(toDoItem: getNewToDoItem())
        } else {
            self.fileCacheManager.addToDoItem(toDoItem: getNewToDoItem())
        }

        NotificationCenter.default.post(name: .toDoListChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    private func getNewToDoItem() -> ToDoItem {
        if let currentItem = currentToDoItem {
            let td = ToDoItem(text: taskTextView.text,
                              importance: getPriorityOfToDo(),
                              deadLine: self.calendarSwitch.isOn ? self.datePickerView.date : nil,
                              status: isEditingItem ? currentItem.status : getPriorityOfToDo() == .important ? .uncompletedImportant : .uncompleted)
            return td
        }

        return ToDoItem(text: taskTextView.text,
                        importance: getPriorityOfToDo(),
                        deadLine: self.calendarSwitch.isOn ? self.datePickerView.date : nil,
                        status:  getPriorityOfToDo() == .important ? .uncompletedImportant : .uncompleted)
    }

    private func getPriorityOfToDo() -> Importance {
        return self.taskPrioritySementedControl.selectedSegmentIndex == 1 ? .standart : self.taskPrioritySementedControl.selectedSegmentIndex == 0 ? .unimportant : .important
    }

}
