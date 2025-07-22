//
//  MainView.swift
//  InstaList
//
//  Created by Jon on 6/16/25.
//

import SwiftUI

struct AuthenticationView: View {
    let appState : AppState
    @State var authenticationStatus = "Unauthenticated"
    
    var body: some View {
        VStack (spacing: 20) {
            Text("Welcome to InstaList")
                .font(.title)
            Button("Authenticate!") {
                Task {
                    authenticationStatus = "Authenticating..."
                    do {
                        try await appState.login()
                        authenticationStatus = "Authenticated!"
                    }
                    catch {
                        authenticationStatus = "Failed! (\(error))"
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    AuthenticationView(appState: AppState())
}
