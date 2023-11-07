//
//  Person.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import Foundation

struct Person {
    let id: Int
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let zipCode: String
    let photoPath: String?
    
    var photoUrl: URL? {
        guard let photoPath = photoPath else {
            return nil
        }
        
        return URL(string: "\(APIService.baseURLString)\(photoPath)")
    }
}

extension Person: Identifiable {}
extension Person: Decodable {}
