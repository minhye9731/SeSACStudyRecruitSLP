//
//  UserInfoDTO.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/13/22.
//

import Foundation

struct UserInfoDTO: Codable {
    var phoneNumber: String
    var fcmToken: String
    var nickname: String
    var birth: String
    var email: String
    var gender: Int
}
