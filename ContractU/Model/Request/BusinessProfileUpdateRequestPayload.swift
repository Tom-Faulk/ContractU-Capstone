//
//  BusinessProfileUpdateRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/2021.
//

struct BusinessProfileUpdateRequestPayload {
    let companyName: String
    let companyURL: String
    let phoneNumber: String
    let zipCode: String
    //let emergencyServiceCallRadius: Double
    let companyDescription: String
}

extension BusinessProfileUpdateRequestPayload: Encodable {}
