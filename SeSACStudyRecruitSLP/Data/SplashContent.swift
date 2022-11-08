//
//  SplashContent.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import Foundation

struct SplashContent {
    let text: String
    let image: String
}

struct SplashContentList {
    var pageContents: [SplashContent] = [
        SplashContent(text: "위치 기반으로 빠르게\n주위 친구들 확인", image: "onboarding_img1"),
        SplashContent(text: "스터디를 원하는 친구를\n찾을 수 있어요", image: "onboarding_img2"),
        SplashContent(text: "SeSAC Study", image: "onboarding_img3")
    ]
}
