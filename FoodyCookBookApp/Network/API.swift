

import Moya

enum API {
    case random
    case search(query: String)
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .random:
            return "random.php" /// We can use randomselection.php api as soon its start to load data correctly
        case .search:
            return "search.php"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .random:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .search(let query):
            return .requestParameters(parameters: ["s" : query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
