//
//  RootView.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation
import SwiftUI


struct RootView : View {
    @State private var viewModel = AppState()

    var body: some View {
        switch viewModel.authState {
        case .unauthenticated:
            AuthenticationView()
        case .authenticated:
            MainAppView()
        }
    }
}
