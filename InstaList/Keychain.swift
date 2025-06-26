//
//  Keychain.swift
//  InstaList
//
//  Created by Jon on 6/24/25.
//

import Foundation
import Security
import OSLog


enum Keychain {

    enum Keys : String {
        case AccessTokenKey = "spotifyAccessToken"
        case RefreshTokenKey = "spotifyRefreshToken"
        case TokenExpirationKey = "spotifyTokenExpiration"
    }
    
    @discardableResult
    static func set(_ value: String, forKey key: Keychain.Keys) -> Bool{
        guard let data = value.data(using: .utf8) else { return false }
        
        // Delete existing item first since the Keychain will complain if we try to add a dupe
        self.clearValue(forKey: key)

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func string(forKey key: Keychain.Keys) -> String? {
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }
    
    @discardableResult
    static func clearValue(forKey key: Keychain.Keys) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
