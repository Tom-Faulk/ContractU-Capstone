//
//  PersonalProfileUpdateRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/2021.
//

struct PersonalProfileUpdateRequestPayload {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let zipCode: String
}

extension PersonalProfileUpdateRequestPayload: Encodable {}
