//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    let button1 = UIButton()
    let button2 = UIButton()
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 300) //Step One

    lazy var scrollView : UIScrollView = {
        let view1 = UIScrollView()
        view1.frame = self.view.bounds
        view1.contentSize = contentViewSize
        view1.backgroundColor = .clear
        return view1
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = .red
        scrollView.addSubview(button1)
        
        button1.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        button1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        button1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        button1.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        scrollView.backgroundColor = .lightGray
        
        print(scrollView.frame.height)
        print(view.frame.height)

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    @objc private func tapped() {
        print("adwd")
    }
    
}
