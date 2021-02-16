//
//  URLSessionExtension.swift
//  FoodyCookBookApp
//
//  Created by Lalit Kant on 15/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import Foundation


enum ApiError: Error {
   case unknownError
   case invalidResponse(_ value: String)
   case invalidUrl
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), ApiError>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(.invalidResponse(error.localizedDescription)))
                return
            }
            guard let response = response, let data = data else {
                result(.failure(.unknownError))
                return
            }
            
            result(.success((response, data)))
        }
    }
}
