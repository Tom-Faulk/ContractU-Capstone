//
//  RegistrationBusinessStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 2/28/21.
//

import Combine
import Foundation

class RegistrationBusinessStore: ObservableObject {
    enum RegistrationBusinessError: Error {
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
        companyName: String,
        companyURL: String,
        phoneNumber: String,
        address: String,
        zipCode: String,
        //emergencyServiceCallRadius: Double,
        companyDescription: String,
        documentUrl: URL
    ) {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/business/v1/register.php")!
        var request = URLRequest(url: url)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        do {
            let documentData = try Data(contentsOf: documentUrl)
        
            request.httpBody = createRequestBody(
                parameters: [
                    "google_credentials_access_token": googleCredentials.accessToken,
                    "google_credentials_expires_in": "\(googleCredentials.expiresIn)",
                    "google_credentials_id_token": googleCredentials.idToken,
                    "email": email,
                    "company_name": companyName,
                    "company_url": companyURL,
                    "company_description": companyDescription,
                    "phone_number": phoneNumber,
                    "address": address,
                    "zip_code": zipCode
                ],
                data: documentData,
                name: "license",
                filename: "license.pdf",
                contentType: "application/pdf",
                boundary: boundary
            )
            
            APIService.shared.request(request, authenticated: false)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        self?.state = .ready
                    case let .failure(error):
                        self?.state = .failed(error: error)
                    }
                }, receiveValue: { [weak self] (credentials: APICredentials) in
                    guard let token = credentials.token else {
                        self?.state = .failed(error: RegistrationBusinessError.noTokenReceived)
                        
                        return
                    }
                    
                    self?.state = .success(token: token)
                })
                .store(in: &cancellables)
        } catch {
            return
        }
    }
}

extension RegistrationBusinessStore: FileUploading {}
