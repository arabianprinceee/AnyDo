//
//  TableViewCell.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/19/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    enum TaskStatus {
        case defaultTask
        case completedTask
        case importantTask
    }
    
    @IBOutlet weak var taskDoneImageView: UIImageView?
    @IBOutlet weak var taskNameLabel: UILabel?
    @IBOutlet weak var taskDeadlineLabel: UILabel?
    
    init(status: TaskStatus, taskName: String, deadline: String? = nil) {
        super.init(style: .default, reuseIdentifier: String(describing: TableViewCell.self))
        self.taskNameLabel?.text = taskName
        self.taskDeadlineLabel?.text = deadline
        switch status {
        case .defaultTask:
            self.taskDoneImageView?.image = UIImage(systemName: "circle")?.withTintColor(.lightGray)
        case .completedTask:
            self.taskDoneImageView?.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen)
        case .importantTask:
            self.taskDoneImageView?.image = UIImage(systemName: "circle")?.withTintColor(.systemRed)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
