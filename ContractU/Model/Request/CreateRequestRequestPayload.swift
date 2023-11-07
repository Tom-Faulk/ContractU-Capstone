//
//  CreateRequestRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import Foundation

struct CreateRequestRequestPayload {
    let title: String
    let description: String
}

extension CreateRequestRequestPayload: Encodable {}
