//
//  BIrthdayView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class BirthdayView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일을 알려주세요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let yearView: InputDateView = {
        let view = InputDateView(frame: .zero)
        view.setAddDateView(plchdr: "1990", term: "년")
        return view
    }()
    
    let monthView: InputDateView = {
        let view = InputDateView(frame: .zero)
        view.setAddDateView(plchdr: "1", term: "월")
        return view
    }()
    
    let dayView: InputDateView = {
        let view = InputDateView(frame: .zero)
        view.setAddDateView(plchdr: "1", term: "일")
        return view
    }()

    let nextButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "다음")
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 240)
        return datepicker
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        [notiLabel, dateView, nextButton, datePicker].forEach {
            self.addSubview($0)
        }
        
        [yearView, monthView, dayView].forEach {
            dateView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        notiLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(dateView.snp.top).offset(-80)
        }
        
        dateView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
        }
        yearView.snp.makeConstraints { make in
            make.leading.equalTo(dateView.snp.leading)
            make.top.equalTo(dateView.snp.top)
            make.bottom.equalTo(dateView.snp.bottom)
            make.width.equalTo(dateView.snp.width).multipliedBy(0.28)
        }
        
        monthView.snp.makeConstraints { make in
            make.centerX.equalTo(dateView.snp.centerX)
            make.top.equalTo(dateView.snp.top)
            make.bottom.equalTo(dateView.snp.bottom)
            make.width.equalTo(dateView.snp.width).multipliedBy(0.28)
        }
        
        dayView.snp.makeConstraints { make in
            make.trailing.equalTo(dateView.snp.trailing)
            make.top.equalTo(dateView.snp.top)
            make.bottom.equalTo(dateView.snp.bottom)
            make.width.equalTo(dateView.snp.width).multipliedBy(0.28)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    
}
