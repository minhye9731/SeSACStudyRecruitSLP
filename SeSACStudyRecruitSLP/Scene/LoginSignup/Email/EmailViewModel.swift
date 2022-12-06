//
//  EmailViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel: CommonViewModel {
    
    // MARK: - property
    struct Input {
        let emailText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    // MARK: - functions
    func transform(input: Input) -> Output {
        let emailForm = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailForm)
        
        let emailResult = input.emailText
            .orEmpty
            .map { emailCheck.evaluate(with: $0) }
            .share()
        
        return Output(validStatus: emailResult, tap: input.tap)
    }
    
}
