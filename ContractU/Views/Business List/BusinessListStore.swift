//
//  BusinessListStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/12/21.
//

import Combine
import Foundation

class BusinessListStore: ObservableObject {
    enum BusinessListError: Error {
        case unexpectedlyCancelled
    }
    
    enum State {
        case ready
        case loading
        case success(businesses: [Business])
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    @Published var query = ""
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .removeDuplicates()
            .flatMap { query in
                self.search(for: query)
            }
            .map { businesses in
                .success(businesses: businesses)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
    
    func search(for query: String) -> AnyPublisher<[Business], Error> {
        var components = URLComponents(string: "\(APIService.baseURLString)/business/v1/list.php")!

        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)
        
        return APIService.shared.request(request)
    }
}
