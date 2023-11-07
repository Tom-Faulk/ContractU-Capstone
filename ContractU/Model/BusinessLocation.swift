//
//  BusinessLocation.swift
//  ContractU
//
//  Created by Eli Daitch on 4/16/2021.
//

import MapKit

struct BusinessLocation: Identifiable {
    let id = UUID()
    let placemark: MKPlacemark
}
