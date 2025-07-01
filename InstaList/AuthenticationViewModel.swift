//
//  MainModel.swift
//  InstaList
//
//  Created by Jon on 6/17/25.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog

@MainActor
@Observable
class AuthenticationViewModel  {
    var authenticationStatus = "Ready to Authenticate!"
    
    private let logger = Logger.init(category: #fileID)
    
    public func authenticate() {
        Task {
            authenticationStatus = "Authenticating..."
            do {
                let response = try await SpotifyAuth.shared.login()
                SpotifySessionManager.shared.saveTokenResponse(response)
                authenticationStatus = "Authenticated!"
            }
            catch {
                self.logger.error("Login failed or was cancelled: \(error.localizedDescription)")
                authenticationStatus = "Failed! (\(error))"
            }
        }
    }
}
