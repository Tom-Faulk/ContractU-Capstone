//
//  GoogleCredentials.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import Foundation

struct GoogleCredentials {
    let accessToken: String
    let expiresIn: Double
    let idToken: String
}

extension GoogleCredentials: Codable {}
