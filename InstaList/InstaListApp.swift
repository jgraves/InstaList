//
//  InstaListApp.swift
//  InstaList
//
//  Created by Jon on 6/11/25.
//

import SwiftUI

@main
struct InstaListApp: App {
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView(appState: appState)
                .task {
                    appState.updateAuthenticatedStatus()
                }
        }
    }
}
