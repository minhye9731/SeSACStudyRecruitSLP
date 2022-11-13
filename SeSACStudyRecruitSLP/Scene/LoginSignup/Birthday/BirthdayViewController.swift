//
//  BirthdayViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import Toast

final class BirthdayViewController: BaseViewController {
    
    // MARK: - property
    let mainView = BirthdayView()
    let today = Date()
    var realAge = 0
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.yearView.dateTextField.becomeFirstResponder()
        mainView.datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setDatePicker()
    }
    
    func setDatePicker() {
        mainView.yearView.dateTextField.inputView = mainView.datePicker
        mainView.monthView.dateTextField.inputView = mainView.datePicker
        mainView.dayView.dateTextField.inputView = mainView.datePicker
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        let bday = formatter.string(from: sender.date)
        
        calculateRealAge(bday: sender.date)
        isvalidAge()
        
        mainView.yearView.dateTextField.text = showSelectedDate(date: bday, start: 0, end: 4)
        mainView.monthView.dateTextField.text = showSelectedDate(date: bday, start: 4, end: 6)
        mainView.dayView.dateTextField.text = showSelectedDate(date: bday, start: 6, end: 8)
    }
    
    func calculateRealAge(bday: Date) {
        let todayYear = Calendar.current.dateComponents([.year], from: Date()).year!
        let birthYear = Calendar.current.dateComponents([.year, .month, .day], from: bday).year!
        let birthDate = Calendar.current.dateComponents([.year, .month, .day], from: bday)

        let compareDateComponents = DateComponents(year: todayYear, month: birthDate.month, day: birthDate.day)
        let compareDate = Calendar.current.date(from: compareDateComponents)!
        
        self.realAge = Date() > compareDate ? (todayYear - birthYear) : (todayYear - birthYear - 1)
    }
    
    func isvalidAge() {
        let bgcolor: UIColor = realAge > 17 ? ColorPalette.green : ColorPalette.gray6
        let txcolor: UIColor = realAge > 17 ? .white : .black
        
        self.mainView.nextButton.configuration?.baseBackgroundColor = bgcolor
        self.mainView.nextButton.configuration?.attributedTitle?.foregroundColor = txcolor
    }
    
    @objc func nextButtonTapped() {
        if realAge < 17 {
            self.mainView.makeToast("새싹스터디는 만17세 이상만 사용할 수 있습니다.", duration: 1.0, position: .center)
        } else {
            let selectedDate = mainView.datePicker.date.toBirthDateForm()
            UserDefaults.standard.set(selectedDate, forKey: "realAge")
            let vc = EmailViewController()
            transition(vc, transitionStyle: .push)
        }
    }
    
    func showSelectedDate(date: String, start: Int, end: Int) -> String {
        let startIndex = date.index(date.startIndex, offsetBy: start)
        let endIndex = date.index(date.startIndex, offsetBy: end)
        let slicedStr = String(date[startIndex ..< endIndex])
        return slicedStr
    }
}

