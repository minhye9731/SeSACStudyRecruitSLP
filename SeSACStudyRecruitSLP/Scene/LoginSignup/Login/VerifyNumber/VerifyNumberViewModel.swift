//
//  VerifyNumberViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class VerifyNumberViewModel: CommonViewModel {
    
    // MARK: - property
    let verify = PublishSubject<LoginResponse>()
    
    struct Input {
        let veriNumText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    // MARK: - functions
    func transform(input: Input) -> Output {
        let veriNumResult = input.veriNumText
            .orEmpty
            .map { $0.count == 6 }
            .share()
        
        return Output(validStatus: veriNumResult, tap: input.tap)
    }
}
