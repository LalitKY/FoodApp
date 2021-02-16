

import Moya

protocol Networkable {
    func fetchRandomMeals(completion: @escaping (Result<MealApiResponse, Error>) -> ())
    func fetchSearchResult(query: String, completion: @escaping (Result<MealApiResponse, Error>) -> ())
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])

    func fetchRandomMeals(completion: @escaping (Result<MealApiResponse, Error>) -> ()) {
        request(target: .random, completion: completion)
    }
    
    func fetchSearchResult(query: String, completion: @escaping (Result<MealApiResponse, Error>) -> ()) {
        request(target: .search(query: query), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
