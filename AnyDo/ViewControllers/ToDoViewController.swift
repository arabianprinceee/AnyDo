//
//  ToDoViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/12/21.
//

import UIKit

class ToDoViewController: UIViewController, UITextViewDelegate {
    
    let datePickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = UIDatePicker.Mode.date
        view.preferredDatePickerStyle = .inline
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskOptionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deleteButtonView: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(taskDescriptionView)
        view.addSubview(taskOptionsView)
        view.addSubview(deleteButtonView)
        view.addSubview(datePickerView)
        setUpTaskDescriptionView()
        setUpDeleteButtonView()
        setUpTaskOptionsView()
        setUpDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTaskDescriptionView() {
        taskDescriptionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        taskDescriptionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        taskDescriptionView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        taskDescriptionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        taskDescriptionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        taskDescriptionView.layer.cornerRadius = 16.0
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        taskDescriptionView.addSubview(textView)
        textView.leftAnchor.constraint(equalTo: taskDescriptionView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: taskDescriptionView.rightAnchor, constant: -8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: taskDescriptionView.frame.width - 16).isActive = true
        textView.topAnchor.constraint(equalTo: taskDescriptionView.topAnchor, constant: 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textView.font = .systemFont(ofSize: 17)
        textView.text = "Введите название задачи"
        textView.textColor = UIColor.lightGray
    }
    
    func setUpTaskOptionsView() {
        taskOptionsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        taskOptionsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        taskOptionsView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        taskOptionsView.topAnchor.constraint(equalTo: taskDescriptionView.bottomAnchor, constant: 16).isActive = true
        taskOptionsView.heightAnchor.constraint(equalToConstant: 112.5).isActive = true
        taskOptionsView.layer.cornerRadius = 16.0
        
        // Верхняя часть, лейбл
        let upLabel = UILabel()
        upLabel.text = "Важность"
        upLabel.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addSubview(upLabel)
        upLabel.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: 16).isActive = true
        upLabel.topAnchor.constraint(equalTo: taskOptionsView.topAnchor, constant: 17).isActive = true
        
        // Верхняя часть, сегментед контрол
        let prioritySegmentedControl = UISegmentedControl(items: [" ↘️ "," ➡️ "," ↗️ "])
        prioritySegmentedControl.selectedSegmentIndex = 1
        prioritySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addSubview(prioritySegmentedControl)
        prioritySegmentedControl.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -16).isActive = true
        prioritySegmentedControl.topAnchor.constraint(equalTo: taskOptionsView.topAnchor, constant: 10).isActive = true
        
        // Разделитель
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "DividerColor")
        divider.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addSubview(divider)
        divider.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: 16).isActive = true
        divider.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -16).isActive = true
        divider.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        divider.topAnchor.constraint(equalTo: taskOptionsView.topAnchor, constant: 56.25).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Нижняя часть, лейбл
        let downLabel = UILabel()
        downLabel.text = "Сделать до"
        downLabel.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addSubview(downLabel)
        downLabel.leftAnchor.constraint(equalTo: taskOptionsView.leftAnchor, constant: 16).isActive = true
        downLabel.bottomAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: -17).isActive = true
        
        // Нижняя часть, свитч
        let calendarSwitch = UISwitch()
        calendarSwitch.translatesAutoresizingMaskIntoConstraints = false
        taskOptionsView.addSubview(calendarSwitch)
        calendarSwitch.rightAnchor.constraint(equalTo: taskOptionsView.rightAnchor, constant: -16).isActive = true
        calendarSwitch.bottomAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: -12.5).isActive = true
    }
    
    func setUpDatePicker() {
        datePickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        datePickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        datePickerView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        datePickerView.topAnchor.constraint(equalTo: taskOptionsView.bottomAnchor, constant: 16).isActive = true
        datePickerView.layer.cornerRadius = 16.0
        datePickerView.layer.masksToBounds = true;
    }
    
    func setUpDeleteButtonView() {
        deleteButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        deleteButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        deleteButtonView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        deleteButtonView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: 16).isActive = true
        deleteButtonView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        deleteButtonView.layer.cornerRadius = 16.0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}
