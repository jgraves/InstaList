//
//  SpotifyTokenResponse.swift
//  InstaList
//
//  Created by Jon on 6/21/25.
//

import Foundation

struct SpotifyTokenResponse: Decodable {
    let AccessToken: String
    let TokenType: String
    let ExpiresIn: Int
    let RefreshToken: String?
    
    var ExpirationTimestamp : String {
        get {
            let expirationDate = Date().addingTimeInterval(TimeInterval(ExpiresIn))
            let expirationTimestamp = expirationDate.timeIntervalSince1970
            return String(expirationTimestamp)
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case AccessToken = "access_token"
        case TokenType = "token_type"
        case ExpiresIn = "expires_in"
        case RefreshToken = "refresh_token"
    }
}
