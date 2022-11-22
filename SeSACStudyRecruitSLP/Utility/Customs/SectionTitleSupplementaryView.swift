//
//  SectionTitleSupplementaryView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/22/22.
//

import UIKit
import SnapKit

final class SectionTitleSupplementaryView: UICollectionReusableView {
      
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = CustomFonts.title6_R12()
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = .orange // test
      self.addSubview(self.titleLabel)
        
      self.titleLabel.snp.makeConstraints {
          $0.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
          $0.centerY.equalTo(self.safeAreaLayoutGuide)
      }
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
      super.prepareForReuse()
      self.prepare(title: nil)
    }
    
    func prepare(title: String?) {
      self.titleLabel.text = title
    }
    
    
    
}
