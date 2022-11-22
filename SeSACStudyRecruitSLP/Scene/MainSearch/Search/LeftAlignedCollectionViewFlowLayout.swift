//
//  LeftAlignedCollectionViewFlowLayout.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/22/22.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach{ layoutAttributes in
            
            if layoutAttributes.representedElementCategory == .cell {
                
                if layoutAttributes.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttributes.frame.origin.x = leftMargin
                
                leftMargin += layoutAttributes.frame.width + minimumInteritemSpacing
                
                maxY = max(layoutAttributes.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}
