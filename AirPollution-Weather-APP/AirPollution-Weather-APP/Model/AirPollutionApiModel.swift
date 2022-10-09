//
//  AirPollutionApiModel.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

struct AirPollutionDatasStruct: Codable {
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let aqi, idx: Int
    let attributions: [Attribution]
    let city: City
    let dominentpol: String
    let iaqi: Iaqi
    let time: Time
    let forecast: Forecast
    let debug: Debug
}

// MARK: - Attribution
struct Attribution: Codable {
    let url: String
    let name: String
    let logo: String?
}

// MARK: - City
struct City: Codable {
    let geo: [Double]
    let name: String
    let url: String
    let location: String
}

// MARK: - Debug
struct Debug: Codable {
    let sync: Date
}

// MARK: - Forecast
struct Forecast: Codable {
    let daily: Daily
}

// MARK: - Daily
struct Daily: Codable {
    let o3, pm10, pm25, uvi: [O3]
}

// MARK: - O3
struct O3: Codable {
    let avg: Int
    let day: String
    let max, min: Int
}

// MARK: - Iaqi
struct Iaqi: Codable {
    let co, h, no2, o3: Co
    let p, pm10, pm25, r: Co
    let so2, t, w, wd: Co
}

// MARK: - Co
struct Co: Codable {
    let v: Double
}

// MARK: - Time
struct Time: Codable {
    let s, tz: String
    let v: Int
    let iso: Date
}
