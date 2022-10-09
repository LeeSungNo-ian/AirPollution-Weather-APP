//
//  NetworkError.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}
