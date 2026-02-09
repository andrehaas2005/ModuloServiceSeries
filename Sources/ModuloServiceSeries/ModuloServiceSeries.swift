import Foundation

@available(iOS 15.0, *)
@available(macOS 12.0, *)
public class NetworkService: NetworkServiceProtocol {
  private let session: URLSession
  
  nonisolated(unsafe) public static let shared = NetworkService()
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func request<T: Decodable>(_ request: APIRequest) async throws -> T {
    
    guard let baseUrl = ProcessInfo.processInfo.environment["BASE_URL"] else {
      throw NetworkError.notfoundUrlBase
    }
    guard var urlComponents = URLComponents(string: baseUrl + request.path.path()),
          let url = urlComponents.url
    else {
      throw NetworkError.invalidURL
    }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "language", value: "pt-BR"),
      URLQueryItem(name: "timezone", value: "America/Sao_Paulo"),
      URLQueryItem(name: "page", value: "1")
      
    ]
    
    guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
      throw NetworkError.notfoundApiKey
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body
    urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
    urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    urlRequest.setValue("accept", forHTTPHeaderField: "application/json")
    session.configuration.timeoutIntervalForRequest = 60
    session.configuration.timeoutIntervalForResource = 60
    
    let (data, response) = try await session.data(for: urlRequest)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.networkError
    }
    
    let decodedData = try JSONDecoder().decode(T.self, from: data)
    return decodedData
  }
}


//{
//    "iso_3166_1": "BR",
//    "zones": [
//      "America/Noronha",
//      "America/Belem",
//      "America/Fortaleza",
//      "America/Recife",
//      "America/Araguaina",
//      "America/Maceio",
//      "America/Bahia",
//      "America/Sao_Paulo",
//      "America/Campo_Grande",
//      "America/Cuiaba",
//      "America/Santarem",
//      "America/Porto_Velho",
//      "America/Boa_Vista",
//      "America/Manaus",
//      "America/Eirunepe",
//      "America/Rio_Branco"
//    ]
//  }
