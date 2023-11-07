//
//  BookAppointmentStore.swift
//  ContractU
//
//  Created by Eli Daitch on 4/17/2021.
//

import Combine
import Foundation

class BookAppointmentStore: ObservableObject {
    enum BookAppointmentError: Error {
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
    
    let business: Business
    
    init(business: Business) {
        self.business = business
    }
    
    func save(title: String, description: String, date: Date) {
        state = .loading
        
        let requestPayload = BookAppointmentRequestPayload(
            businessID: business.id,
            title: title,
            description: description,
            date: date
        )
        
        guard let data = try? APIService.shared.jsonEncoder.encode(requestPayload) else {
            state = .failed(error: BookAppointmentError.encodingFailed)
            
            return
        }
        
        let url = URL(string: "\(APIService.baseURLString)/appointment/v1/book.php")!
        
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
