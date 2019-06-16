//
//  ServiceHelper.swift
//  Weather
//
//  Created by Vinoth Varatharajan on 16/06/19.
//  Copyright © 2019 Vin. All rights reserved.
//

import Foundation

class WeatherHelper {

    class func request<T: Codable>(router: WeatherManager, completion: @escaping (Result<T, Error>) -> ()) {

        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in

            guard error == nil else {
                completion(.failure(error!))
                if let errorDesc = error?.localizedDescription {
                    print(errorDesc)
                }
                return
            }
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            }
            catch (let error){
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
