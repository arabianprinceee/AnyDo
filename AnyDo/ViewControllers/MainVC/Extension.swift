//
//  Extension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/19/21.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM"
        
        if let deadline = myTasks[indexPath.row].deadline {
            print(dateFormatterPrint.string(from: deadline))
            cell.configure(status: myTasks[indexPath.row].status, taskName: myTasks[indexPath.row].text, deadline: dateFormatterPrint.string(from: deadline))
            return cell
        }
        
        cell.configure(status: myTasks[indexPath.row].status, taskName: myTasks[indexPath.row].text)
        return cell
    }
    
}
