//
//  PassThroughView.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit

// 출처: https://ios-development.tistory.com/1022
class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // superview가 터치 이벤트를 받을 수 있도록, 해당 뷰 (subview)가 터치되면 nil을 반환하고 다른 뷰일경우 UIView를 반환
        return hitView == self ? nil : hitView
    }
}
