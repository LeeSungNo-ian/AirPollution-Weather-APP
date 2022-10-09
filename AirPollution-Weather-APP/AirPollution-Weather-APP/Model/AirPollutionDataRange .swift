//
//  AirPollutionDataRange .swift
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
}
