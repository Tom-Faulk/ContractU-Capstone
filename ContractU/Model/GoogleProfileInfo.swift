//
//  GoogleUserInfo.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import Foundation

struct GoogleProfileInfo {
    let email: String // = "john@doe.com" // TODO: This should not be hardcoded
    let givenName: String?
    let familyName: String?
}

extension GoogleProfileInfo: Decodable {}
