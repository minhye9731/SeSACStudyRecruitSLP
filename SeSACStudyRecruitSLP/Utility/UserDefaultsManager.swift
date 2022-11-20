//
//  UserDefaultsManager.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/18/22.
//

import Foundation

struct UserDefaultsManager {

    // MARK: - 기타
    // 첫 실행여부
    
    // MARK: - 번호인증
    @UserDefaultsWrapper(key: "fcmTokenSU", defaultValue: "")
    static var fcmTokenSU: String
    
    @UserDefaultsWrapper(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefaultsWrapper(key: "phoneNumSU", defaultValue: "")
    static var phoneNumSU: String
    
    @UserDefaultsWrapper(key: "idtoken", defaultValue: "")
    static var idtoken: String
    

    
    // MARK: - 로그인
    
    // _id
    // __v
    
    @UserDefaultsWrapper(key: "uid", defaultValue: "")
    static var uid: String
    
    @UserDefaultsWrapper(key: "phoneNumber", defaultValue: "")
    static var phoneNumber: String
    
    @UserDefaultsWrapper(key: "email", defaultValue: "")
    static var email: String
    
    @UserDefaultsWrapper(key: "FCMtoken_LogigResponse", defaultValue: "")
    static var FCMtokenLoginResponse: String
    
    @UserDefaultsWrapper(key: "nick", defaultValue: "")
    static var nick: String
    
    @UserDefaultsWrapper(key: "birth", defaultValue: "")
    static var birth: String
    
    @UserDefaultsWrapper(key: "gender", defaultValue: 0)
    static var gender: Int
    
    @UserDefaultsWrapper(key: "study", defaultValue: "") // 마이페이지에서 입력한 스터디
    static var study: String
    
    @UserDefaultsWrapper(key: "comment", defaultValue: []) // 리뷰하기에서 받은 후기 배열
    static var comment: Array
    
    @UserDefaultsWrapper(key: "reputation", defaultValue: [0]) // 리뷰하기에서 받은 평가항목 배열
    static var reputation: Array
    
    @UserDefaultsWrapper(key: "sesac", defaultValue: 0) // 현재 선택한 새싹 이미지
    static var sesac: Int
    
    @UserDefaultsWrapper(key: "sesacCollection", defaultValue: []) // 보유하고 있는 새싹 배열
    static var sesacCollection: Array
    
    @UserDefaultsWrapper(key: "background", defaultValue: 0) // 현재 선택한 배경 이미지
    static var background: Int
    
    @UserDefaultsWrapper(key: "backgroundCollection", defaultValue: []) // 보유하고 있는 배경 배열
    static var backgroundCollection: Array
    
    @UserDefaultsWrapper(key: "purchaseToken", defaultValue: []) // 새싹샵 구매후 받은 토큰 배열(Android)
    static var purchaseToken: Array
    
    @UserDefaultsWrapper(key: "transactionId", defaultValue: []) // 새싹샵 구매후 받은 id 배열(iOS)
    static var transactionId: Array
    
    @UserDefaultsWrapper(key: "reviewedBefore", defaultValue: []) // 스터디를 함께하고 내가 리뷰 남긴 유저 uid 배열
    static var reviewedBefore: Array
    
    @UserDefaultsWrapper(key: "reportedNum", defaultValue: 0) // 신고하기를 받은 숫자
    static var reportedNum: Int
    
    @UserDefaultsWrapper(key: "reportedUser", defaultValue: []) // 내가 신고한 유저 uid 배열
    static var reportedUser: Array
    
    @UserDefaultsWrapper(key: "dodgepenalty", defaultValue: 0) // 스터디 함께하기 취소 여부,  취소 전 : 0, 취소 후 : 1
    static var dodgepenalty: Int
    
    @UserDefaultsWrapper(key: "dodgeNum", defaultValue: 0) // 스터디 함께하기를 취소한 숫자
    static var dodgeNum: Int
    
    @UserDefaultsWrapper(key: "ageMin", defaultValue:18) // 스터디 함께하기 친구 찾기 시 최소 나이
    static var ageMin: Int
    
    @UserDefaultsWrapper(key: "ageMax", defaultValue: 65) // 스터디 함께하기 친구 찾기 시 최대 나이
    static var ageMax: Int
    
    @UserDefaultsWrapper(key: "searchable", defaultValue: 0) // 내 정보 - 정보 관리 - [내 번호 검색 허용]  거부 : 0, 허용 : 1
    static var searchable: Int
    
    @UserDefaultsWrapper(key: "createdAt", defaultValue: "") // 회원가입일
    static var createdAt: String
    
    // MARK: - 회원가입
    @UserDefaultsWrapper(key: "nickNameSU", defaultValue: "")
    static var nickNameSU: String
    
    @UserDefaultsWrapper(key: "realAgeSU", defaultValue: "")
    static var realAgeSU: String
    
    @UserDefaultsWrapper(key: "emailSU", defaultValue: "")
    static var emailSU: String
    
    @UserDefaultsWrapper(key: "genderSU", defaultValue: "")
    static var genderSU: String
    
}
