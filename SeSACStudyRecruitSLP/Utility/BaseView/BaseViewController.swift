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
    }
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}

