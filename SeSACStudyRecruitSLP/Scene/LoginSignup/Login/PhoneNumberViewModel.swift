//
//  PhoneNumberViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneNumberViewModel: CommonViewModel {
    
    // MARK: - property
    struct Input {
        let phoneNumberText: ControlProperty<String?>
        let phoneNumberEditing: ControlEvent<Void>
        let phoneNumberDone: ControlEvent<Void>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let changeForm: Driver<String>
        let tap: ControlEvent<Void>
    }
    
    // MARK: - functions
    func transform(input: Input) -> Output {
        let phoneNumForm = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        let phoneNumCheck = NSPredicate(format: "SELF MATCHES %@", phoneNumForm)
        
        print("유효성 검사할 폰넘버 = \(input.phoneNumberText)")

        let phoneNumberResult = input.phoneNumberText
            .orEmpty
            .map { phoneNumCheck.evaluate(with: $0) }
            .share()
        
        
        let changedForm = input.phoneNumberText
            .orEmpty
            .map { $0.autoAddHyphen() }
            .asDriver(onErrorJustReturn: "")
              
        return Output(validStatus: phoneNumberResult, changeForm: changedForm, tap: input.tap)
    }
    
}
