//
//  AuthenticationRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/2021.
//

import Foundation

struct AuthenticationRequestPayload {
    let email: String
    let googleCredentials: GoogleCredentials
}

extension AuthenticationRequestPayload: Encodable {}
