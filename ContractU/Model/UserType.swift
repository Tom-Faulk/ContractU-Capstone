//
//  UserType.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/1/21.
//

import Foundation

enum UserType: String, RawRepresentable {
    case person
    case business
}

extension UserType: Decodable {}
