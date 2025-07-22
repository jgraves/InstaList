//
//  AppState.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation
import OSLog

@MainActor
@Observable
class AppState {
    
    let sessionManager = SpotifySessionManager()
    let spotifyAuth = SpotifyAuth()
    let logger = Logger.init(category: #fileID)
    
    enum AuthState {
        case initializing
        case unauthenticated
        case authenticated
    }

    var authState: AuthState = .initializing

    func updateAuthenticatedStatus() {
        authState = sessionManager.isLoggedIn ? .authenticated : .unauthenticated
    }

    func login() async throws {
        let response = try await spotifyAuth.login()
        sessionManager.saveTokenResponse(response)
        updateAuthenticatedStatus()
    }

    func logout() {
        sessionManager.clearSession()
        updateAuthenticatedStatus()
    }
}

