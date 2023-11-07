//
//  Business.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/12/21.
//

import Foundation

struct Business {
    let id: Int
    let companyName: String
    let companyUrl: String
    let companyDescription: String
    let phoneNumber: String
    let address: String
    let zipCode: String
    let photoPath: String?
    
    var photoUrl: URL? {
        guard let photoPath = photoPath else {
            return nil
        }
        
        return URL(string: "\(APIService.baseURLString)\(photoPath)")
    }
}

extension Business: Identifiable {}
extension Business: Decodable {}
