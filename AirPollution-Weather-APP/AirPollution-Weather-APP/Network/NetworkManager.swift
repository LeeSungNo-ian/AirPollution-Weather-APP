//
//  NetworkManager.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/10.
//

import Foundation

final class NetworkManager {
    
    typealias NetworkCompletion = (Result<[List], NetworkError>) -> Void
    
    func fetchAirPollutionData(completion: @escaping NetworkCompletion) {
        let urlString = RequestURL().airPollutionURL + APIKey().apiKey
        performRequest(with: urlString) { result in completion(result) }
    }
    
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
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
            
            if let youtubeData = self.parseJSON(safeData) {
                completion(.success(youtubeData))
            } else {
                completion(.failure(.parseError))
            }
            
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> [List]? {
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

