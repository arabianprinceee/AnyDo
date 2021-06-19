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
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell
        else
        { return UITableViewCell() }
        cell.configure(status: myTasks[indexPath.row].status, taskName: myTasks[indexPath.row].text, deadline: myTasks[indexPath.row].deadline?.description)
        return cell
    }
    
}
