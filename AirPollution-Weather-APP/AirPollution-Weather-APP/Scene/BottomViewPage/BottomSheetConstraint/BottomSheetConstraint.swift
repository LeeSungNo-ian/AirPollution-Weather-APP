//
//  BottomSheetConstraint.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/29.
//

import UIKit

enum BottomSheetConstraint {
    static let duration = 0.5
    static let cornerRadius = 12.0
    static let barViewTopSpacing = 5.0
    static let barViewSize = CGSize(width: UIScreen.main.bounds.width * 0.09, height: 5.0)
    static let bottomSheetRatio: (BottomSheetMode) -> Double = { mode in
        switch mode {
        case .tip:
            return 0.9 // 값이 클수록 BottomSheet의 길이가 줄어든다
        case .full:
            return 0.2 // 값이 커질 수록 뷰는 밑으로 내려간다
        }
    }
    
    static let bottomSheetYPosition: (BottomSheetMode) -> Double = { mode in
        Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
    }
}
