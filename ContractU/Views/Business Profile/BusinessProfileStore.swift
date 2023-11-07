//
//  BusinessProfileStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import Combine
import Foundation

class BusinessProfileStore: ObservableObject {
    enum State {
        case ready
        case loading
        case success(business: Business)
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/business/v1/profile.php")!
        let request = URLRequest(url: url)

        return APIService.shared.request(request)
            .map { (business: Business) in
                .success(business: business)
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}
