//
//  RequestFeedStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import Combine
import Foundation

class RequestFeedStore: ObservableObject {
    enum State {
        case ready
        case loading
        case success(requests: [Request])
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchRequests() {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/request/v1/list.php")!
        
        let request = URLRequest(url: url)
        
        APIService.shared.request(request)
            .receive(on: DispatchQueue.main)
            .map { (requests: [Request]) in
                .success(requests: requests)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}
