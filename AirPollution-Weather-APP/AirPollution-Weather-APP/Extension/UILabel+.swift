//
//  UILabel+.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/11.
//

import UIKit

extension UILabel {
    func changeTextWeightSpecificRange(label: UILabel, fontSize: CGFloat, fontWeight: UIFont.Weight, range: String) -> UILabel {
        guard let text = label.text else { return UILabel() }
        let attributeString = NSMutableAttributedString(string: text)
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        label.attributedText = attributeString
        
        return label
    }
}
