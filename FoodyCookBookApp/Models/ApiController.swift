//
//  ApiController.swift
//  FoodyCookBookApp
//
//  Created by Kuldeep LNU on 15/02/21.
//  Copyright © 2021 Test. All rights reserved.
//

import Foundation

class ApiController: NSObject {
    private var urlString: String?
    
    private override init() {
    }
    
    internal init(url: String?) {
        self.urlString = url
    }
    
    func makeApiCall<T: Codable>(completion: @escaping ([T]?, ApiError?) -> Void) {
        
        guard let url = URL(string : urlString ?? "") else {
            completion(nil, .invalidUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, .invalidResponse(value: error.localizedDescription))
                return
            }
            
            guard let data = data else {
                completion(nil, .unknownError)
                return
            }
            
            do {
                let items = try JSONDecoder().decode([T].self, from: data)
                completion(items, nil)
            } catch let error {
                completion(nil, .invalidResponse(value: error.localizedDescription))
            }
        }.resume()
    }
}
