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
}
