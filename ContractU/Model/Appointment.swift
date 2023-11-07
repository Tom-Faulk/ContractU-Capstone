//
//  Appointment.swift
//  ContractU
//
//  Created by Eli Daitch on 4/17/2021.
//

import Foundation

struct Appointment {
    let id: Int
    let title: String
    let description: String
    let date: Date
    let business: Business
}

extension Appointment: Decodable {}
extension Appointment: Identifiable {}
