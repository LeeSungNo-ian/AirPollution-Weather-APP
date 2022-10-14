//
//  UIColor+.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    class var airPollutionVeryGoodColor: UIColor { UIColor(hex: 0x147EFB) }
    class var airPollutionGoodColor: UIColor { UIColor(hex: 0x53D769) }
    class var airPollutionBadColor: UIColor { UIColor(hex: 0xFECB2E) }
    class var airPollutionVeryBadColor: UIColor { UIColor(hex: 0xFC3D39) }
    
    class var bottomSheetBarViewColor: UIColor { UIColor(hex: 0x606166) }
    class var bottomSheetContentBackGroundColor: UIColor { UIColor(hex: 0x2C2C2D) }
    class var textFieldBackGroundColor: UIColor { UIColor(hex: 0x383A3E) }
}
