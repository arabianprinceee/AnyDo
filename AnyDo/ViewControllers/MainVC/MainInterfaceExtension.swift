//
//  InterfaceSetupExtension.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/27/21.
//

import UIKit

extension MainViewController {

    // MARK: Interface setup

    func setUpTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 54, bottom: 0, right: 0)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: doneTasksLabel.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpViewTitle() {
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.text = NSLocalizedString("mainTitle", comment: "")
        viewTitle.font = .boldSystemFont(ofSize: FontSizes.title)

        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: DesignConstants.titleTopConstraint),
            viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }

    func setUpDoneTasksLabel() {
        doneTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTasksLabel.font = .systemFont(ofSize: FontSizes.underTitleLabels)
        doneTasksLabel.textColor = .lightGray
        updateDoneTasksLabel()

        NSLayoutConstraint.activate([
            doneTasksLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: DesignConstants.doneTasksToTitleConstraint),
            doneTasksLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }

    func setUpShowHideButton() {
        showHideTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showHideTasksButton.setTitle(NSLocalizedString("hide", comment: ""), for: .normal)
        showHideTasksButton.setTitleColor(.systemBlue, for: .normal)
        showHideTasksButton.titleLabel?.font = .boldSystemFont(ofSize: FontSizes.underTitleLabels)
        showHideTasksButton.addTarget(self, action: #selector(onShowHideTasksButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            showHideTasksButton.centerYAnchor.constraint(equalTo: doneTasksLabel.centerYAnchor),
            showHideTasksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: DesignConstants.showHideButtonRightConstraing)
        ])
    }

    func setUpAddButton() {
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = UIColor(named: "AddButtonColor")
        addItemButton.layer.cornerRadius = DesignConstants.addItemButtonFrames / 2

        addItemButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addItemButton.imageView?.tintColor = UIColor.white
        addItemButton.imageView?.contentMode = .scaleToFill

        addItemButton.addTarget(self, action: #selector(onAddItemButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DesignConstants.addItemButtonBottomConstraint),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames),
            addItemButton.heightAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames)
        ])
    }

}
