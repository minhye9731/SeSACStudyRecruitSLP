//
//  MyQueueStateResponse.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/20/22.
//

import Foundation

struct MyQueueStateResponse: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String? // 옵셔널값 필수
}
