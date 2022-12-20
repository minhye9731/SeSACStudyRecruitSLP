//
//  PageMode.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import SnapKit

enum SearchMode {
    case aroundSesac
    case acceptedReq
}

enum MatchingMode {
    case normal
    case standby
    case matched
}

enum userCardMode {
    case myProfile
    case otherSesac
}

//enum MapGenderMode: Int {
//    case woman = 0
//    case man
//    case all
//}

enum PopupMode {
    case withdraw
    case askStudy
    case acceptStudy
    case cancelStudy
    
    var popupHeight: ConstraintRelatableTarget {
        switch self {
        case .askStudy: return 178
        default : return 160
        }
    }
    
    var mainAnnouncement: String? {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        case .askStudy:
            return "스터디를 요청할게요!"
        case .acceptStudy:
            return "스터디를 수락할까요?"
        case .cancelStudy:
            return "스터디를 취소하겠습니까?"
        }
    }
    
    var subAnnouncement: String? {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        case .askStudy:
            return "상대방이 요청을 수락하면\n채팅방에서 대화를 나눌 수 있어요"
        case .acceptStudy:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        case .cancelStudy:
            return "스터디를 취소하시면 패널티가 부과됩니다"
        }
    }
}


