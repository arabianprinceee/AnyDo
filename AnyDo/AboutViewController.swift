//
//  ViewController.swift
//  AnyDo
//
//  Created by Анас Бен Мустафа on 6/6/21.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appVersionLabel.text = getAppVersion()
        self.appIconImageView.image = UIImage(named: "IconImage")
    }
    
    func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "AnyDo v\(version)"
        }
        return ""
    }

}

