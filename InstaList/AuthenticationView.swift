//
//  MainView.swift
//  InstaList
//
//  Created by Jon on 6/16/25.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        Button(viewModel.authenticationStatus, systemImage:"arrow.up.circle.fill",action: viewModel.authenticate)
    }
}

#Preview {
    AuthenticationView()
}
