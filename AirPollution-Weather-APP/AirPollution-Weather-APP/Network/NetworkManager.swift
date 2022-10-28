//
//  NetworkManager.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

final class NetworkManager: ObservableObject {

    typealias AirPollutionNetworkCompletion = (Result<[List], NetworkError>) -> Void
    
    static let shared = NetworkManager()

    @Published var airPollutionValueData: [List] = []

    var airPollutionURL = ""

    func fectchData(coordinate: [Double]) {
        airPollutionURL = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(coordinate[0])&lon=\(coordinate[1])&appid="
        
        fetchAirPollutionData { result in
            switch result {
            case Result.success(let airPollutonValueData):
                self.airPollutionValueData = airPollutonValueData
                
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAirPollutionData(completion: @escaping AirPollutionNetworkCompletion) {
        let urlString = self.airPollutionURL + APIKey().apiKey
        airPollutionPerformRequest(with: urlString) { result in completion(result) }
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
}

