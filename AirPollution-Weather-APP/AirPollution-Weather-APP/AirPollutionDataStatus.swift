//
//  AirPollutionDataStatus .swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit

enum AirPollutionDataStatus: String {
    case veryGood
    case good
    case bad
    case veryBad
    
    var statusTextLabel: String {
        switch self {
        case .veryGood: return "청량한 공기에요!"
        case .good: return "좋지도, 나쁘지도 않은 공기에요."
        case .bad: return "공기가 탁해요.."
        case .veryBad: return "마스크 없으면 나오지도 말기.."
        }
    }

    var statusColor: UIColor {
        switch self {
        case .veryGood: return .airPollutionVeryGoodColor
        case .good: return .airPollutionGoodColor
        case .bad: return .airPollutionBadColor
        case .veryBad: return .airPollutionVeryBadColor
        }
    }
    
    var statusBlurAlpha: Double {
        switch self {
        case .veryGood: return 0.0
        case .good: return 0.2
        case .bad: return 0.75
        case .veryBad: return 1.0
        }
    }
    
    var characterImageSet: UIImage {
        switch self {
        case .veryGood: return UIImage(named: "AirPollutionVeryGood")!
        case .good: return UIImage(named: "AirPollutionGood")!
        case .bad: return UIImage(named: "AirPollutionBad")!
        case .veryBad: return UIImage(named: "AirPollutionVeryBad")!
        }
    }
}
