//
//  EditBusinessProfileStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import Combine
import SwiftUI

class EditBusinessProfileStore: ObservableObject {
    enum EditBusinessProfileError: Error {
        case encodingFailed
        case noTokenReceived
    }
    
    enum State {
        case ready
        case loading
        case success
        case failed(error: Error)
    }
    
    let business: Business
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init(business: Business) {
        self.business = business
    }
    
    func save(
        companyName: String,
        companyURL: String,
        phoneNumber: String,
        address: String,
        zipCode: String,
        //emergencyServiceCallRadius: Double,
        companyDescription: String,
        newPhoto: UIImage?
    ) {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/business/v1/update-profile.php")!
        var request = URLRequest(url: url)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let resizedPhoto = newPhoto?.resize(
            targetSize: CGSize(width: 300, height: 300)
        )
        let resizedPhotoData = resizedPhoto?.jpegData(compressionQuality: 1)
        
        request.httpBody = createRequestBody(
            parameters: [
                "company_name": companyName,
                "company_url": companyURL,
                "phone_number": phoneNumber,
                "address": address,
                "zip_code": zipCode,
                //"emergency_service_call_radius": emergencyServiceCallRadius,
                "company_description": companyDescription
            ],
            data: resizedPhotoData,
            name: "photo",
            filename: "photo.jpg",
            contentType: "image/jpg",
            boundary: boundary
        )

        return APIService.shared.request(request)
            .map {
                .success
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

extension EditBusinessProfileStore: FileUploading {}
