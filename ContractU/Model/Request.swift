//
//  Request.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/2/2021.
//

import Foundation

struct Request {
    let id: Int
    let title: String
    let description: String
    let person: Person
}

extension Request: Decodable {}
extension Request: Identifiable {}
