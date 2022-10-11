//
//  NetworkManager.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

final class NetworkManager {
    
    typealias AirPollutionNetworkCompletion = (Result<[List], NetworkError>) -> Void
    typealias WeatherDataNetworkCompletion = (Result<Temp, NetworkError>) -> Void
    
    var airPollutionURL = ""
    
    func fetchAirPollutionData(completion: @escaping AirPollutionNetworkCompletion) {
        let urlString = self.airPollutionURL + APIKey().apiKey
        airPollutionPerformRequest(with: urlString) { result in completion(result) }
    }
    
    func fetchWeatherData(cityName: String, completion: @escaping WeatherDataNetworkCompletion) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(APIKey().apiKey)"
        weatherDataPerformRequest(with: urlString) { result in completion(result) }
    }
    
    private func airPollutionPerformRequest(with urlString: String, completion: @escaping AirPollutionNetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            if let needData = self.parseAirPollutionJSON(safeData) {
                completion(.success(needData))
            } else {
                completion(.failure(.parseError))
            }
            
        }
        task.resume()
    }
    
    private func weatherDataPerformRequest(with urlString: String, completion: @escaping WeatherDataNetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            if let needData = self.parseWeatherDataJSON(safeData) {
                completion(.success(needData))
            } else {
                completion(.failure(.parseError))
            }
            
        }
        task.resume()
    }
    
    private func parseAirPollutionJSON(_ weatherData: Data) -> [List]? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodeData = try decoder.decode(AirPollutionDatasStruct.self, from: weatherData)
            return decodeData.list
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func parseWeatherDataJSON(_ weatherData: Data) -> Temp? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodeData = try decoder.decode(WeatherInformation.self, from: weatherData)
            return decodeData.temp
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

