//
//  CreateRequestStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import Combine
import Foundation

class CreateRequestStore: ObservableObject {
    enum CreateRequestError: Error {
        case encodingFailed
    }
    
    enum State {
        case ready
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func save(title: String, description: String) {
        state = .loading
        
        let requestPayload = CreateRequestRequestPayload(title: title, description: description)
        
        guard let data = try? APIService.shared.jsonEncoder.encode(requestPayload) else {
            state = .failed(error: CreateRequestError.encodingFailed)
            
            return
        }
        
        let url = URL(string: "\(APIService.baseURLString)/request/v1/create.php")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        APIService.shared.request(request)
            .receive(on: DispatchQueue.main)
            .map { (response: CreationResponse) in
                .success
            }
            .catch { error in
                Just(.failed(error: error))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}
