//
//  SpotifySessionManager.swift
//  InstaList
//
//  Created by Jon on 6/26/25.
//

import Foundation

final class SpotifySessionManager {
    static let shared = SpotifySessionManager()

    private init() {}

    var accessToken: String? {
        Keychain.string(forKey: Keychain.Keys.AccessTokenKey)
    }

    var refreshToken: String? {
        Keychain.string(forKey: Keychain.Keys.RefreshTokenKey)
    }

    var isLoggedIn: Bool {
        accessToken != nil && !isTokenExpired
    }

    var isTokenExpired: Bool {
        guard let timestampString = Keychain.string(forKey: Keychain.Keys.TokenExpirationKey),
              let timestamp = TimeInterval(timestampString)
        else {
            return true
        }
        return Date() >= Date(timeIntervalSince1970: timestamp)
    }

    func clearSession() {
        Keychain.clearValue(forKey: Keychain.Keys.AccessTokenKey)
        Keychain.clearValue(forKey: Keychain.Keys.RefreshTokenKey)
        Keychain.clearValue(forKey: Keychain.Keys.TokenExpirationKey)
    }
        
    func saveTokenResponse(_ response: SpotifyTokenResponse) {
        Keychain.set(response.AccessToken, forKey: Keychain.Keys.AccessTokenKey)
        Keychain.set(response.ExpirationTimestamp, forKey: Keychain.Keys.TokenExpirationKey)
        
        if let refreshToken = response.RefreshToken { //Refresh token is only returned on initial token exchange
            Keychain.set(refreshToken, forKey: Keychain.Keys.RefreshTokenKey)
        }
    }
}
