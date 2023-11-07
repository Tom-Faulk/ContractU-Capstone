//
//  CreatePostRequestPayload.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/13/2021.
//

import Foundation

struct CreatePostRequestPayload {
    let title: String
    let description: String
}

extension CreatePostRequestPayload: Encodable {}
