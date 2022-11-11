//
//  GenderViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import Toast

final class GenderViewController: BaseViewController {
    
    // MARK: - property
    let mainView = GenderView()
    var femaleSelected = false
    var maleSelected = false
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        mainView.FemaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        mainView.MaleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
    }
    
    @objc func femaleButtonTapped() {
        femaleSelected.toggle()
        maleSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    @objc func maleButtonTapped() {
        maleSelected.toggle()
        femaleSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    func isValidGender() {
        let value =  (maleSelected && !femaleSelected) || (!maleSelected && femaleSelected)
        let bgcolor: UIColor = value ? ColorPalette.green : ColorPalette.gray6
        let txcolor: UIColor = value ? .white : .black

        self.mainView.nextButton.configuration?.baseBackgroundColor = bgcolor
        self.mainView.nextButton.configuration?.attributedTitle?.foregroundColor = txcolor
    }
    
    func changeGenderBtnClr() {
        mainView.FemaleButton.configuration?.baseBackgroundColor = femaleSelected ? ColorPalette.whitegreen : .white
        mainView.MaleButton.configuration?.baseBackgroundColor = maleSelected ? ColorPalette.whitegreen : .white

        mainView.FemaleButton.configuration?.background.strokeColor = femaleSelected ? ColorPalette.whitegreen : ColorPalette.gray4
        mainView.MaleButton.configuration?.background.strokeColor = maleSelected ? ColorPalette.whitegreen : ColorPalette.gray4
    }
    
    @objc func nextButtonTapped() {
        if !maleSelected && !femaleSelected {
            self.mainView.makeToast("성별을 선택해 주세요.", duration: 1.0, position: .center)
        } else {
            let value = (maleSelected && !femaleSelected) ? 1 : 0
            print("성별선택 저장값 = \(value)")
            UserDefaults.standard.set(value, forKey: "gender")
            changeRootVC(vc: MainViewController())
        }
    }
    
}
