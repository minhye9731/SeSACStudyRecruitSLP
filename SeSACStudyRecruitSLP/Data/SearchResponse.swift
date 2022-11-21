//
//  SearchResponse.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/21/22.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
