//
//  APICredentials.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import Foundation

struct APICredentials {
    let token: String?
    let userType: UserType?
}

extension APICredentials: Decodable {}
