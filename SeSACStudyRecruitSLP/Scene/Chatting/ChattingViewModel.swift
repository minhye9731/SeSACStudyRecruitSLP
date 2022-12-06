//
//  ChattingViewModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/6/22.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel: CommonViewModel {
    
    // MARK: - Input & Output
    struct Input {
        let chatText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    // MARK: - functions
    func transform(input: Input) -> Output {
        let chatResult = input.chatText
            .orEmpty
            .map { $0.count >= 1 }
            .share()
        
        return Output(validStatus: chatResult, tap: input.tap)
    }
    
}
