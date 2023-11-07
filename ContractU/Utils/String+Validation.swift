//
//  String+Validation.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/17/2021.
//

import Foundation
import SwiftUI

extension String {
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        let result = phoneTest.evaluate(with: self)
        
        return result
    }
    
    var isValidZipCode: Bool {
        let zipCodeRegex = "^\\d{5}(-\\d{4})?$"
        let zipCodeTest = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        
        let result = zipCodeTest.evaluate(with: self)
        
        return result
    }
    
    var isValidURL: Bool {
        guard
            let url = URL(string: self),
            UIApplication.shared.canOpenURL(url)
        else {
            return false
        }
        
        return true
    }
}
