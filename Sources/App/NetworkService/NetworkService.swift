//
//  NetworkService.swift
//
//
//  Created by Dmitriy Suprun on 3.10.24.
//

import Foundation


protocol INetworkService {
    func fetchModel<T: Decodable>(model: T.Type, completion: @escaping @Sendable (Result<T, Error>) -> Void)
}

final class NetworkService: INetworkService {
    
    func fetchModel<T: Decodable>(model: T.Type, completion: @escaping @Sendable (Result<T, Error>) -> Void) {
        guard let url = URL(string: "https://todoappvapor-production.up.railway.app/hello") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            do {
                let decodedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

