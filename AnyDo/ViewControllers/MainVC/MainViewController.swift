//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties
    
    let addItemButton = UIButton()
    let viewTitle = UILabel()
    let doneTasksLabel = UILabel()
    let showHideTasksButton = UIButton()
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 300) //Step One
    
    lazy var scrollView : UIScrollView = {
        let view1 = UIScrollView()
        view1.contentSize = contentViewSize
        view1.backgroundColor = .clear
        return view1
    }()
    
    let doneTasksQuantity: Int = 0
    
    
    // MARK: Enums
    
    enum DesignConstants {
        static var titleTopConstraint: CGFloat { return 60 }
        static var titleLeftConstraint: CGFloat { return 32 }
        static var doneTasksToTitleConstraint: CGFloat { return 18 }
        static var addItemButtonFrames: CGFloat { return 44 }
        static var addItemButtonBottomConstraint: CGFloat { return -54 }
        static var showHideButtonRightConstraing: CGFloat { return -32 }
    }
    
    enum FontSizes {
        static var title: CGFloat { return 34 }
        static var underTitleLabels: CGFloat { return 15 }
    }
    
    
    // MARK: System methods
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(scrollView)
        view.addSubview(addItemButton)
        
        scrollView.addSubview(viewTitle)
        scrollView.addSubview(doneTasksLabel)
        scrollView.addSubview(showHideTasksButton)
        
        setUpAddButton()
        setUpViewTitle()
        setUpDoneTasksLabel()
        setUpShowHideButton()
        
    }
    
    
    // MARK: Private methods
    
    private func setUpViewTitle() {
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.text = NSLocalizedString("mainTitle", comment: "")
        viewTitle.font = .boldSystemFont(ofSize: FontSizes.title)
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: DesignConstants.titleTopConstraint),
            viewTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }
    
    private func setUpDoneTasksLabel() {
        doneTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        doneTasksLabel.text = "\(NSLocalizedString("doneTasks", comment: "")) \(doneTasksQuantity)"
        doneTasksLabel.font = .systemFont(ofSize: FontSizes.underTitleLabels)
        doneTasksLabel.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            doneTasksLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: DesignConstants.doneTasksToTitleConstraint),
            doneTasksLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: DesignConstants.titleLeftConstraint)
        ])
    }
    
    private func setUpShowHideButton() {
        showHideTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
        showHideTasksButton.setTitleColor(.systemBlue, for: .normal)
        showHideTasksButton.titleLabel?.font = .boldSystemFont(ofSize: FontSizes.underTitleLabels)
        showHideTasksButton.addTarget(self, action: #selector(showHideTasksButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            showHideTasksButton.centerYAnchor.constraint(equalTo: doneTasksLabel.centerYAnchor),
            showHideTasksButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: DesignConstants.showHideButtonRightConstraing)
        ])
    }
    
    private func setUpAddButton() {
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = UIColor(named: "AddButtonColor")
        addItemButton.layer.cornerRadius = DesignConstants.addItemButtonFrames / 2
        
        addItemButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addItemButton.imageView?.tintColor = UIColor.white
        addItemButton.imageView?.contentMode = .scaleToFill
        
        addItemButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DesignConstants.addItemButtonBottomConstraint),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames),
            addItemButton.heightAnchor.constraint(equalToConstant: DesignConstants.addItemButtonFrames)
        ])
    }
    
    
    // MARK: Objc methods
    
    @objc private func addItemButtonTapped() {
        let vc = ToDoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func showHideTasksButtonTapped() {
        if showHideTasksButton.titleLabel?.text == NSLocalizedString("show", comment: "") {
            showHideTasksButton.setTitle(NSLocalizedString("hide", comment: ""), for: .normal)
            
            // TODO
        
        } else {
            showHideTasksButton.setTitle(NSLocalizedString("show", comment: ""), for: .normal)
            
            // TODO
            
        }
    }
    
}
