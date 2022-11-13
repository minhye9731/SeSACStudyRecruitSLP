//
//  NickNameViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class NickNameViewModel: CommonViewModel {
    
    // MARK: - property
    struct Input {
        let nicknameText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    // MARK: - functions
    func transform(input: Input) -> Output {
        let nicknameResult = input.nicknameText
            .orEmpty
            .map { $0.count >= 1 && $0.count <= 10 }
            .share()
        return Output(validStatus: nicknameResult, tap: input.tap)
    }
    
}
