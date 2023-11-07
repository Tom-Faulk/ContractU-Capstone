//
//  BookAppointmentRequestPayload.swift
//  ContractU
//
//  Created by Eli Daitch on 4/17/2021.
//

import Foundation

struct BookAppointmentRequestPayload {
    let businessID: Int
    let title: String
    let description: String
    let date: Date
}

extension BookAppointmentRequestPayload: Encodable {}
