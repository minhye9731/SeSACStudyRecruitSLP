//
//  ReusableProtocol.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import Foundation

import UIKit

private protocol ReusableProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewHeaderFooterView: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
