//
//  ViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for family in UIFont.familyNames {
            
            print(family)
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("======== \(names)")
            }
            
        }
        
        
        
    }


}

