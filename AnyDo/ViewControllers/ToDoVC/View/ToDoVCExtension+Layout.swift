//
//  ToDoVCInterfaceSetupExtension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/27/21.
//

import UIKit

extension ToDoViewController {

    // MARK: Setup & configuration methods

    /// NavigationBar

    func setUpNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: DesignConstants.defaultNavBarHeight))
        let navigationItem = UINavigationItem(title: NSLocalizedString("task", comment: ""))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(onDismissVC))
        navigationItem.rightBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)
    }

    /// Description

    func setUpTaskDescriptionView() {
        taskDescriptionView.backgroundColor = UIColor(named: "CardsBackground")
        taskDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionView.layer.cornerRadius = DesignConstants.defaultCornRadius

        NSLayoutConstraint.activate([
            taskDescriptionView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            taskDescriptionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            taskDescriptionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: DesignConstants.defaultPadding),
            taskDescriptionView.heightAnchor.constraint(equalToConstant: DesignConstants.taskDescriptionViewHeight)
        ])

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

    func setUpTaskOptionsView() {
        taskOptionsView.backgroundColor = UIColor(named: "CardsBackground")
        taskOptionsView.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.axis = .vertical

        NSLayoutConstraint.activate( [
            taskOptionsView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            taskOptionsView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            taskOptionsView.topAnchor.constraint(equalTo: taskDescriptionView.bottomAnchor, constant: DesignConstants.defaultPadding)
        ])

        taskOptionsView.layer.cornerRadius = DesignConstants.defaultCornRadius

        configureImportanceCell(leftText: NSLocalizedString("priority", comment: ""), segmentedControl: taskPrioritySementedControl)

        configureCalendarCell(leftTopText: NSLocalizedString("doUntil", comment: ""), leftDownText: nil, calendarSwitch: calendarSwitch)
    }

    func configureImportanceCell(leftText: String, segmentedControl: UISegmentedControl) {
        let containerView = UIView()

        let leftLabel = UILabel()
        leftLabel.text = leftText

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1

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

    func configureCalendarCell(leftTopText: String, leftDownText: String? = nil, calendarSwitch: UISwitch) {
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

    func configureCalendar(for date: Date) {
        calendarDivider = configureSeparator()

        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.minimumDate = Date()
        datePickerView.date = date
        print(date)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false

        taskOptionsView.addArrangedSubview(datePickerView)

        NSLayoutConstraint.activate([
            datePickerView.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: DesignConstants.datePickerLeftRightTopConstraints),
            datePickerView.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -DesignConstants.datePickerLeftRightTopConstraints)
        ])
    }

    @discardableResult
    func configureSeparator() -> UIView {
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

    func setUpDeleteButtonView() {
        deleteButtonView.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        deleteButtonView.setTitleColor(.red, for: .normal)
        deleteButtonView.backgroundColor = UIColor(named: "CardsBackground")

        deleteButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate( [
            deleteButtonView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2 * DesignConstants.defaultPadding),
            deleteButtonView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            deleteButtonView.topAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: DesignConstants.defaultPadding),
            deleteButtonView.heightAnchor.constraint(equalToConstant: DesignConstants.deleteButtonHeight)
        ])

        deleteButtonView.layer.cornerRadius = DesignConstants.defaultCornRadius
    }

}
