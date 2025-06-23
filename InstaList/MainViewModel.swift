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
class MainViewModel  {
    var authenticationStatus = "Ready to Authenticate!"
    
    private let auth = SpotifyAuth()
    private let logger = Logger(subsystem: "InstaList", category: "MainViewModel")
    
    public func authenticate() {
        Task {
            authenticationStatus = "Authenticating..."
            do {
                try await auth.login()
                authenticationStatus = "Authenticated!"
            }
            catch {
                self.logger.error("Login failed or was cancelled: \(error.localizedDescription)")
                authenticationStatus = "Failed! (\(error))"
            }
        }
    }
}
