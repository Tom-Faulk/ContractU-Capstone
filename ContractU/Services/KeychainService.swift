//
//  KeychainService.swift
//  ContractU
//
//  Created by Tom Faulkner on 3/11/21.
//

import Foundation

class KeychainService {
    enum Key: String {
        case accessToken
        case userType
    }
    
    static let shared = KeychainService()
    
    func has(key: Key) -> Bool {
        get(key: key) == nil ?
            false :
            true
    }

    func get(key: Key) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard
            status == noErr,
            let data = dataTypeRef as? Data
        else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func set(key: Key, value: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        SecItemAdd(query as CFDictionary, nil)
    }

    func remove(key: Key) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue
        ]

        SecItemDelete(query as CFDictionary)
    }
}
