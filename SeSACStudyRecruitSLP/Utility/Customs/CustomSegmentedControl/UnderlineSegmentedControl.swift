//
//  UnderlineSegmentedControl.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/6/22.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    
    // MARK: - property
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = ColorPalette.green
        self.addSubview(view)
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.clearBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - functions
    private func clearBackgroundAndDivider() {
        let img = UIImage()
        self.setBackgroundImage(img, for: .normal, barMetrics: .default)
        self.setBackgroundImage(img, for: .selected, barMetrics: .default)
        self.setBackgroundImage(img, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(img, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.underlineView.frame.origin.x = underlineFinalXPosition
        }
        )
    }
}
