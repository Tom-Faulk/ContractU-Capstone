//
//  Post.swift
//  ContractU
//
//  Created by Arthur Babcock on 3/13/21.
//

import Foundation

struct Post {
    let id: Int
    let title: String
    let description: String
    let business: Business
}

extension Post: Decodable {}
extension Post: Identifiable {}
