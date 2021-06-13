//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

class ToDoViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties
    
    var calendarSwitch: UISwitch = UISwitch()
    var taskPrioritySementedControl: UISegmentedControl = UISegmentedControl(items: [" ↘️ "," ➡️ "," ↗️ "])
    var taskTextView: UITextView = UITextView()
    var calendarDivider: UIView?
    let datePickerView: UIDatePicker = UIDatePicker()
    let taskOptionsView: UIStackView = UIStackView()
    let taskDescriptionView: UIView = UIView()
    let deleteButtonView: UIButton = UIButton()
    
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
    }
    
    enum FontSizes {
        static var taskTextViewFontSize: CGFloat { return 17 }
    }
    
    // MARK: System methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(taskDescriptionView)
        view.addSubview(taskOptionsView)
        view.addSubview(deleteButtonView)
        setUpTaskDescriptionView()
        setUpTaskOptionsView()
        setUpDeleteButtonView()
        
        self.navigationItem.title = NSLocalizedString("task", comment: "")
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: NSLocalizedString("saveButton", comment: ""), style: .done, target: nil, action: nil), animated: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // MARK: Setup & configuration methods
    
    private func setUpTaskDescriptionView() {
        taskDescriptionView.backgroundColor = UIColor(named: "CardsBackground")
        
        taskDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate( [
            taskDescriptionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.defaultPadding),
            taskDescriptionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DesignConstants.defaultPadding),
            taskDescriptionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DesignConstants.defaultPadding),
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
        
        NSLayoutConstraint.activate( [
            taskTextView.leftAnchor.constraint(equalTo: taskDescriptionView.leftAnchor, constant: DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.rightAnchor.constraint(equalTo: taskDescriptionView.rightAnchor, constant: -DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.widthAnchor.constraint(equalToConstant: taskDescriptionView.frame.width - 2 * DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.topAnchor.constraint(equalTo: taskDescriptionView.topAnchor, constant: DesignConstants.taskTextViewLeftRightTopConstraints),
            taskTextView.heightAnchor.constraint(equalToConstant: DesignConstants.taskTextViewHeight)
        ])
    }
    
    private func setUpTaskOptionsView() {
        taskOptionsView.backgroundColor = UIColor(named: "CardsBackground")
        taskOptionsView.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.axis = .vertical
        
        NSLayoutConstraint.activate( [
            taskOptionsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.defaultPadding),
            taskOptionsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DesignConstants.defaultPadding),
            taskOptionsView.topAnchor.constraint(equalTo: taskDescriptionView.bottomAnchor, constant: DesignConstants.defaultPadding)
        ])
        
        taskOptionsView.layer.cornerRadius = DesignConstants.defaultCornRadius
        
        taskPrioritySementedControl.selectedSegmentIndex = 1
        
        calendarSwitch.isOn = false
        
        // Switch value change handling
        calendarSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        configureCell(leftText: NSLocalizedString("priority", comment: ""), rightView: taskPrioritySementedControl)
        
        configureCell(leftText: NSLocalizedString("doUntil", comment: ""), rightView: calendarSwitch, separatorNeeded: false)
        
        if calendarSwitch.isOn {
            configureCalendar()
        }
        
        deleteButtonView.layoutIfNeeded()
    }
    
    private func setUpDeleteButtonView() {
        deleteButtonView.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        deleteButtonView.setTitleColor(.red, for: .normal)
        deleteButtonView.backgroundColor = UIColor(named: "CardsBackground")
        
        deleteButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        deleteButtonView.translatesAutoresizingMaskIntoConstraints = false
        deleteButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.defaultPadding).isActive = true
        deleteButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DesignConstants.defaultPadding).isActive = true
        deleteButtonView.topAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: DesignConstants.defaultPadding).isActive = true
        deleteButtonView.heightAnchor.constraint(equalToConstant: DesignConstants.deleteButtonHeight).isActive = true
        
        deleteButtonView.layer.cornerRadius = DesignConstants.defaultCornRadius
    }
    
    private func configureCell(leftText: String, rightView: UIView, separatorNeeded: Bool = true) {
        let containerView = UIView()
        
        let leftLabel = UILabel()
        leftLabel.text = leftText
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(leftLabel)
        containerView.addSubview(rightView)
        
        leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate( [
            rightView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -DesignConstants.defaultPadding),
            rightView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            leftLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            leftLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftLabel.rightAnchor.constraint(equalTo: rightView.leftAnchor, constant: -DesignConstants.defaultPadding)
        ])
        
        containerView.heightAnchor.constraint(equalToConstant: DesignConstants.taskOptionsCellHeight).isActive = true
        
        taskOptionsView.addArrangedSubview(containerView)
        
        if separatorNeeded {
            configureSeparator()
        }
    }
    
    private func configureCalendar() {
        calendarDivider = configureSeparator()
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        taskOptionsView.addArrangedSubview(datePickerView)
        
        NSLayoutConstraint.activate( [
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
        
        divider.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: DesignConstants.defaultPadding).isActive = true
        divider.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -DesignConstants.defaultPadding).isActive = true
        divider.heightAnchor.constraint(equalToConstant: DesignConstants.dividerHeight).isActive = true
        
        return divider
    }
    
    // MARK: Objc methods
    
    @objc private func switchChanged(sender: UISwitch)
    {
        if (sender.isOn) {
            configureCalendar()
        } else {
            datePickerView.removeFromSuperview()
            calendarDivider?.removeFromSuperview()
            taskOptionsView.layoutIfNeeded()
        }
    }
    
    @objc private func buttonTapped(sender: UIButton)
    {
        print("button tapped")
    }
    
}
