//
//  UITextField+.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/11.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        // width값에 원하는 padding 값을 넣어줍니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12.0, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
