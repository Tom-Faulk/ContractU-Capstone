//
//  Data+appendString.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
