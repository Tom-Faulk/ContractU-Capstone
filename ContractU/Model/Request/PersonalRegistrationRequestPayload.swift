//
//  PersonalRegistrationRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/4/21.
//


struct PersonalRegistrationRequestPayload {
    let googleCredentials: GoogleCredentials
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let zipCode: String
}

extension PersonalRegistrationRequestPayload: Encodable {}
