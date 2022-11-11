//
//  BaseViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func giveColorString(label: UILabel, colorStr: String, color: UIColor) {
        
        let attributeLabelStr = NSMutableAttributedString(string: label.text!)
        attributeLabelStr.addAttribute(.foregroundColor, value: color, range: (label.text! as NSString).range(of: colorStr))
        
        label.attributedText = attributeLabelStr
    }
    
}

