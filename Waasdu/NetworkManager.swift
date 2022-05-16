//
//  NetworkManager.swift
//  Waadsu test
//
//  Created by Алексей on 14.05.2022.
//

import Foundation


class NetworkManager {
    
    func loadData <T: Decodable> (url: URL, parameters: [String: String]? = nil, completion: @escaping (Result<T,Error>) -> Void) {
        let request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let postString = try? JSONSerialization.data(withJSONObject: parameters ?? [:])
//        request.httpBody = postString

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("\(error)")
                }
                if let data = data {
                    do{
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decodedData))
                        }
                    } catch {
                        completion(.failure(error))
                    }

                }
        }
        task.resume()
    }
}
