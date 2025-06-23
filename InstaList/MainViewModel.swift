//
//  MainModel.swift
//  InstaList
//
//  Created by Jon on 6/17/25.
//

import Foundation
import SwiftUI
import SwiftData


@MainActor
@Observable
class MainViewModel  {
    var authenticationStatus = "Ready to Authenticate!"
    private let auth = SpotifyAuth()
    
    public func authenticate() {
        Task {
            authenticationStatus = "Authenticating..."
            do {
                try await auth.login()
                authenticationStatus = "Authenticated!"
            }
            catch {
                authenticationStatus = "Failed! (\(error))"
            }
        }
    }
}
