//
//  InstaListApp.swift
//  InstaList
//
//  Created by Jon on 6/11/25.
//

import SwiftUI

@main
struct InstaListApp: App {
    
    private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView(appState: appState)
        }
    }
}
