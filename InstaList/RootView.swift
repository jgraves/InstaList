//
//  RootView.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation
import SwiftUI


struct RootView : View {
    private var appState : AppState

    init(appState : AppState) {
        self.appState = appState
    }
    
    var body: some View {
        switch appState.authState {
        case .unauthenticated:
            AuthenticationView()
        case .authenticated:
            MainAppView()
        }
    }
}
