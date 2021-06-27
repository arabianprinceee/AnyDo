//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

class ToDoViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    
    let fileCacheManager: FileCacheImplementation
    
    var dateOfTask: UILabel = UILabel()
    var calendarSwitch: UISwitch = UISwitch()
    var taskPrioritySementedControl: UISegmentedControl = UISegmentedControl(items: [" ↘️ "," ➡️ "," ↗️ "])
    var taskTextView: UITextView = UITextView()
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
        view.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 115)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Enums
    
    enum DesignConstants {
        static var defaultPadding: CGFloat { return 16 }
        static var taskOptionsCellHeight: CGFloat { return 58.5 }
        static var dividerHeight: CGFloat { return 0.5 }
        static var taskDescriptionViewHeight: CGFloat { return 120 }
        static var taskTextViewHeight: CGFloat { return 100 }
        static var datePickerLeftRightTopConstraints: CGFloat { return 8 }
        static var taskTextViewLeftRightTopConstraints: CGFloat { return 8 }
        static var deleteButtonHeight: CGFloat { return 56 }
        static var defaultCornRadius: CGFloat { return 16 }
        static var defaultNavBarHeight: CGFloat { return 44 }
        static var calendarInfoStackHeight: CGFloat { return 40 }
    }
    
    enum FontSizes {
        static var taskTextViewFontSize: CGFloat { return 17 }
    }
    
    // MARK: Initialization
    
    init(fileCacheManager: FileCacheImplementation) {
        self.fileCacheManager = fileCacheManager
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
        
        datePickerView.addTarget(self, action: #selector(handlingDateChanges), for: .valueChanged)
    }
    
    // MARK: Setup & configuration methods
    
    /// NavigationBar
    
    private func setUpNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: DesignConstants.defaultNavBarHeight))
        let navigationItem = UINavigationItem(title: NSLocalizedString("task", comment: ""))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    /// Description
    
    private func setUpTaskDescriptionView() {
        taskDescriptionView.backgroundColor = UIColor(named: "CardsBackground")
        taskDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate( [
            taskDescriptionView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            taskDescriptionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            taskDescriptionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: DesignConstants.defaultPadding),
            taskDescriptionView.heightAnchor.constraint(equalToConstant: DesignConstants.taskDescriptionViewHeight)
        ])
        
        taskDescriptionView.layer.cornerRadius = DesignConstants.defaultCornRadius
        
        taskTextView.backgroundColor = UIColor(named: "CardsBackground")
        taskTextView.translatesAutoresizingMaskIntoConstraints = false
        taskTextView.delegate = self
        taskTextView.font = .systemFont(ofSize: FontSizes.taskTextViewFontSize)
        taskTextView.text = NSLocalizedString("enterTaskName", comment: "")
        taskTextView.textColor = UIColor.lightGray
        
        taskDescriptionView.addSubview(taskTextView)
        
        NSLayoutConstraint.activate([
            taskTextView.leftAnchor.constraint(equalTo: taskDescriptionView.leftAnchor, constant: DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.rightAnchor.constraint(equalTo: taskDescriptionView.rightAnchor, constant: -DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.topAnchor.constraint(equalTo: taskDescriptionView.topAnchor, constant: DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.bottomAnchor.constraint(equalTo: taskDescriptionView.bottomAnchor, constant: -DesignConstants.taskTextViewLeftRightTopConstraints)
        ])
    }
    
    /// Task options
    
    private func setUpTaskOptionsView() {
        taskOptionsView.backgroundColor = UIColor(named: "CardsBackground")
        taskOptionsView.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.axis = .vertical
        
        NSLayoutConstraint.activate( [
            taskOptionsView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            taskOptionsView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            taskOptionsView.topAnchor.constraint(equalTo: taskDescriptionView.bottomAnchor, constant: DesignConstants.defaultPadding)
        ])
        
        taskOptionsView.layer.cornerRadius = DesignConstants.defaultCornRadius
        
        taskPrioritySementedControl.selectedSegmentIndex = 1
        
        calendarSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        configureImportanceCell(leftText: NSLocalizedString("priority", comment: ""), segmentedControl: taskPrioritySementedControl)
        
        configureCalendarCell(leftTopText: NSLocalizedString("doUntil", comment: ""), leftDownText: nil, calendarSwitch: calendarSwitch)
    }
    
    private func configureImportanceCell(leftText: String, segmentedControl: UISegmentedControl) {
        let containerView = UIView()
        
        let leftLabel = UILabel()
        leftLabel.text = leftText
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(leftLabel)
        containerView.addSubview(segmentedControl)
        
        leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        segmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate( [
            segmentedControl.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -DesignConstants.defaultPadding),
            segmentedControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            leftLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            leftLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftLabel.rightAnchor.constraint(equalTo: segmentedControl.leftAnchor, constant: -DesignConstants.defaultPadding)
        ])
        
        containerView.heightAnchor.constraint(equalToConstant: DesignConstants.taskOptionsCellHeight).isActive = true
        
        taskOptionsView.addArrangedSubview(containerView)
        
        configureSeparator()
    }
    
    private func configureCalendarCell(leftTopText: String, leftDownText: String? = nil, calendarSwitch: UISwitch) {
        let generalHStack = UIStackView()
        let leftSideVStack = UIStackView()
        
        generalHStack.alignment = .center
        generalHStack.axis = .horizontal
        leftSideVStack.axis = .vertical
        leftSideVStack.alignment = .leading
        
        let leftTopLabel = UILabel()
        leftTopLabel.text = leftTopText
        
        dateOfTask.text = leftDownText
        
        leftTopLabel.translatesAutoresizingMaskIntoConstraints = false
        dateOfTask.translatesAutoresizingMaskIntoConstraints = false
        
        leftSideVStack.addArrangedSubview(leftTopLabel)
        leftSideVStack.addArrangedSubview(dateOfTask)
        
        generalHStack.addArrangedSubview(leftSideVStack)
        generalHStack.addArrangedSubview(calendarSwitch)
        
        taskOptionsView.addArrangedSubview(generalHStack)
        
        NSLayoutConstraint.activate([
            generalHStack.heightAnchor.constraint(equalToConstant: DesignConstants.taskOptionsCellHeight),
            generalHStack.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -DesignConstants.defaultPadding),
            generalHStack.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: DesignConstants.defaultPadding),
            
            calendarSwitch.centerYAnchor.constraint(equalTo: generalHStack.centerYAnchor),
            
            leftSideVStack.heightAnchor.constraint(equalToConstant: DesignConstants.calendarInfoStackHeight)
        ])
    }
    
    private func configureCalendar() {
        calendarDivider = configureSeparator()
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.minimumDate = Date()
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        taskOptionsView.addArrangedSubview(datePickerView)
        
        NSLayoutConstraint.activate([
            datePickerView.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: DesignConstants.datePickerLeftRightTopConstraints),
            datePickerView.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -DesignConstants.datePickerLeftRightTopConstraints)
        ])
    }
    
    @discardableResult
    private func configureSeparator() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "DividerColor")
        divider.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addArrangedSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: DesignConstants.defaultPadding),
            divider.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -DesignConstants.defaultPadding),
            divider.heightAnchor.constraint(equalToConstant: DesignConstants.dividerHeight)
        ])
        
        return divider
    }
    
    /// Delete button
    
    private func setUpDeleteButtonView() {
        deleteButtonView.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        deleteButtonView.setTitleColor(.red, for: .normal)
        deleteButtonView.backgroundColor = UIColor(named: "CardsBackground")
        
        deleteButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        deleteButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate( [
            deleteButtonView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            deleteButtonView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            deleteButtonView.topAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: DesignConstants.defaultPadding),
            deleteButtonView.heightAnchor.constraint(equalToConstant: DesignConstants.deleteButtonHeight)
        ])
        
        deleteButtonView.layer.cornerRadius = DesignConstants.defaultCornRadius
    }
    
    // MARK: Private methods
    
    private func getStringFromDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy"
        return df.string(from: datePickerView.date)
    }
    
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // MARK: Objc methods
    
    @objc private func switchChanged(sender: UISwitch) {
        if (sender.isOn) {
            configureCalendar()
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
    
    @objc private func buttonTapped(sender: UIButton) {
        print("button tapped")
    }
    
    @objc private func handlingDateChanges(sender: UIDatePicker) {
        dateOfTask.textColor = .systemBlue
        dateOfTask.font = .boldSystemFont(ofSize: 13)
        dateOfTask.text = getStringFromDate()
    }
    
    @objc private func dismissVC() {
        fileCacheManager.addToDoItem(toDoItem: ToDoItem(text: self.taskTextView.text, importance: .standart, deadLine: nil, status: .uncompleted))
        NotificationCenter.default.post(name: .toDoListChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
