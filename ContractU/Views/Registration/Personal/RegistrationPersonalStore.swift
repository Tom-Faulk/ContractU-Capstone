//
//  RegistrationBusinessStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import Combine
import Foundation

class RegistrationPersonalStore: ObservableObject {
    enum RegistrationPersonalError: Error {
        case encodingFailed
        case noTokenReceived
    }
    
    enum State {
        case ready
        case loading
        case success(token: String)
        case failed(error: Error)
    }
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func register(
        googleCredentials: GoogleCredentials,
        email: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        zipCode: String
    ) {
        state = .loading
        
        let requestPayload = PersonalRegistrationRequestPayload(
            googleCredentials: googleCredentials,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            zipCode: zipCode
        )
        
        guard let data = try? APIService.shared.jsonEncoder.encode(requestPayload) else {
            state = .failed(error: RegistrationPersonalError.encodingFailed)
            
            return
        }
        
        let url = URL(string: "\(APIService.baseURLString)/person/v1/register.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        return APIService.shared.request(request, authenticated: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    self?.state = .failed(error: error)
                }
            }, receiveValue: { [weak self] (credentials: APICredentials) in
                guard let token = credentials.token else {
                    self?.state = .failed(error: RegistrationPersonalError.noTokenReceived)
                    
                    return
                }
                
                self?.state = .success(token: token)
            })
            .store(in: &cancellables)
    }
}
