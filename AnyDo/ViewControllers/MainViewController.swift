//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UINavigationController {
    
    let button1 = UIButton()
    let button2 = UIButton()
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 300) //Step One

    lazy var scrollView : UIScrollView = {
        let view1 = UIScrollView()
        view1.contentSize = contentViewSize
        view1.backgroundColor = .clear
        return view1
    }()
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "some title"
        
        view.addSubview(scrollView)
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = .red
        scrollView.addSubview(button1)
        
        button1.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        button1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        button1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        view.addSubview(button2)
        setUpAddButton()
        
        
        button1.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        scrollView.backgroundColor = .lightGray
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    private func setUpAddButton() {
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.backgroundColor = UIColor(named: "AddButtonColor")
        
        button2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54).isActive = true
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button2.layer.cornerRadius = 22
        
        button2.setImage(UIImage(systemName: "plus"), for: .normal)
        button2.imageView?.tintColor = UIColor.white
        button2.imageView?.contentMode = .scaleAspectFit
//        button2.imageEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 5.0)
//        button2.setTitle("+", for: .normal)
//        button2.setTitleColor(.white, for: .normal)
//        button2.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        
        button2.addTarget(self, action: #selector(addNewToDoItem), for: .touchUpInside)
    }
    
    @objc private func addNewToDoItem() {
        let vc = ToDoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc private func tapped() {
        print("adwd")
    }
    
}
