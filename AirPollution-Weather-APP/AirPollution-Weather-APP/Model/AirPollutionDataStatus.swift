//
//  AirPollutionDataStatus .swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import UIKit

enum AirPollutionDataStatus: String {
    case good
    case soso
    case bad
    case veryBad
    
    var statusColor: UIColor {
        switch self {
        case .good: return UIColor.systemBlue
        case .soso: return UIColor.systemGreen
        case .bad: return UIColor.systemYellow
        case .veryBad: return UIColor.systemRed
        }
    }
    
    var statusBlurAlpha: Double {
        switch self {
        case .good: return 0.0
        case .soso: return 0.6
        case .bad: return 0.8
        case .veryBad: return 0.95
        }
    }
}
