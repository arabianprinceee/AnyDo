//
//  TableViewCell.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/19/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskDoneImageView: UIImageView?
    @IBOutlet weak var taskNameLabel: UILabel?
    @IBOutlet weak var taskDeadlineLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(status: TaskStatus, taskName: String, deadline: String? = nil) {
        self.taskNameLabel?.text = taskName
        self.taskDeadlineLabel?.text = deadline
        switch status {
        case .uncompleted:
            self.taskDoneImageView?.image = UIImage(systemName: "circle")
            taskDoneImageView?.tintColor = .lightGray
        case .completed:
            self.taskDoneImageView?.image = UIImage(systemName: "checkmark.circle.fill")
            taskDoneImageView?.tintColor = .systemGreen
        case .uncompletedImportant:
            self.taskDoneImageView?.image = UIImage(systemName: "circle")
            taskDoneImageView?.tintColor = .systemRed
        }
    }
    
}
