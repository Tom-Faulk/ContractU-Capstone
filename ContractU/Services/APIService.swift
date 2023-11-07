//
//  APIService.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import Combine
import UIKit

class APIService {
    enum APIError: Error {
        case missingAccessToken
        case missingResponse
    }
    
    static let baseURLString = "https://cgi.luddy.indiana.edu/~team64/team-64/php"
    static let shared = APIService()
    
    lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        return URLSession(configuration: config)
    }()
    
    lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return decoder
    }()
    
    lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        
        return encoder
    }()
    
    func request(_ receivedRequest: URLRequest, authenticated: Bool = true) -> AnyPublisher<Void, Error> {
        if
            let data = receivedRequest.httpBody,
            let dataString = String(data: data, encoding: .utf8)
        {
            print("💼 REQUEST DATA 💼")
            print(dataString)
        }
        
        var request = receivedRequest
        
        if authenticated {
            guard let token = KeychainService.shared.get(key: .accessToken) else {
                return Fail(error: APIError.missingAccessToken)
                    .eraseToAnyPublisher()
            }
            
            var httpHeaders = [String: String]()
            
            if let currentHeaders = request.allHTTPHeaderFields {
                httpHeaders = currentHeaders
            }
            
            httpHeaders["App-Authorization"] = "Bearer \(token)"
            
            request.allHTTPHeaderFields = httpHeaders
        }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .print("🚀 REQUEST 🚀")
            .tryMap() { element -> Void in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw APIError.missingResponse
                }
                
                if let response = String(data: element.data, encoding: .utf8) {
                    print("💾 RESPONSE DATA 💾:")
                    print(response)
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("💥 RESPONSE 💥:")
                    print(httpResponse)
                    
                    throw URLError(.badServerResponse)
                }
                
                return
            }
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(_ receivedRequest: URLRequest, authenticated: Bool = true) -> AnyPublisher<T, Error> {
        if
            let data = receivedRequest.httpBody,
            let dataString = String(data: data, encoding: .utf8)
        {
            print("💼 REQUEST DATA 💼")
            print(dataString)
        }
        
        var request = receivedRequest
        
        if authenticated {
            guard let token = KeychainService.shared.get(key: .accessToken) else {
                return Fail(error: APIError.missingAccessToken)
                    .eraseToAnyPublisher()
            }
            
            var httpHeaders = [String: String]()
            
            if let currentHeaders = request.allHTTPHeaderFields {
                httpHeaders = currentHeaders
            }
            
            httpHeaders["App-Authorization"] = "Bearer \(token)"
            
            request.allHTTPHeaderFields = httpHeaders
        }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .print("🚀 REQUEST 🚀")
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw APIError.missingResponse
                }
                
                if let response = String(data: element.data, encoding: .utf8) {
                    print("💾 RESPONSE DATA 💾:")
                    print(response)
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("💥 RESPONSE 💥:")
                    print(httpResponse)
                    
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            //.print()
            .eraseToAnyPublisher()
    }
    
    func fetchImage(at url: URL) -> AnyPublisher<UIImage?, Never> {
        urlSession.dataTaskPublisher(for: url)
            .map { element in
                UIImage(data: element.data)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
