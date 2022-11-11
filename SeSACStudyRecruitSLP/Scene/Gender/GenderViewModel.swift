//
//  GenderViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import Foundation
import RxSwift
import RxCocoa

//final class GenderViewModel: CommonViewModel {
//
//    // MARK: - property
//    struct Input {
//        let maleTap: ControlEvent<Void>
//        let femaleTap: ControlEvent<Void>
//        let nextTap: ControlEvent<Void>
//    }
//
//    struct Output {
//        let validStatus: Observable<Bool>
//        let tap: ControlEvent<Void>
//    }
//
//    // MARK: - functions
//    func transform(input: Input) -> Output {
//
//        let nicknameResult = input.emailText
//            .orEmpty
//            .map { emailCheck.evaluate(with: $0) }
//            .share()
//
//        return Output(validStatus: nicknameResult, tap: input.tap)
//    }
//
//}
