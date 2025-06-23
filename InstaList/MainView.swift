//
//  MainView.swift
//  InstaList
//
//  Created by Jon on 6/16/25.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        Button(viewModel.authenticationStatus, systemImage:"arrow.up.circle.fill",action: viewModel.authenticate)
    }
}

#Preview {
    MainView()
}
