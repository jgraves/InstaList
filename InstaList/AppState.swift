//
//  AppState.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation

@MainActor
@Observable
class AppState {
    enum AuthState {
        case unauthenticated
        case authenticated
    }

    var authState: AuthState = .unauthenticated

    func checkAuthentication() async {
        // Logic to load saved session/token
    }

    func login() async {
        // Do login logic
        authState = .authenticated
    }

    func logout() {
        // Do logout logic
        authState = .unauthenticated
    }
}
