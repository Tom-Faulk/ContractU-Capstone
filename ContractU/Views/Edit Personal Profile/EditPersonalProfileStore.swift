//
//  EditPersonalProfileStore.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import Combine
import UIKit

class EditPersonalProfileStore: ObservableObject {
    enum EditPersonalProfileError: Error {
        case encodingFailed
        case noTokenReceived
    }
    
    enum State {
        case ready
        case loading
        case success
        case failed(error: Error)
    }
    
    let person: Person
    
    @Published var state: State = .ready {
        didSet {
            print(state)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init(person: Person) {
        self.person = person
    }
    
    func save(
        firstName: String,
        lastName: String,
        phoneNumber: String,
        zipCode: String,
        newPhoto: UIImage?
    ) {
        state = .loading
        
        let url = URL(string: "\(APIService.baseURLString)/person/v1/update-profile.php")!
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
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "zip_code": zipCode,
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

extension EditPersonalProfileStore: FileUploading {}
