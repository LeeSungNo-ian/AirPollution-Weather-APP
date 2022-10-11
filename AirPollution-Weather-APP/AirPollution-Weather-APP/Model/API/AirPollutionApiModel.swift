//
//  AirPollutionApiModel.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

// MARK: - Welcome
struct AirPollutionDatasStruct: Codable {
    let coord: Coord
    let list: [List]
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - List
struct List: Codable {
    let main: Main
    let components: [String: Double]
    let dt: Int
}

// MARK: - Main
struct Main: Codable {
    let aqi: Int
}
