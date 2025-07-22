//
//  LoggedInView.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation
import SwiftUI

public struct LoggedInView: View {
    
    let appState: AppState
    
    public var body: some View {
        Text("You're all logged in. Welcome to Instalist!")
            .background(Color.blue)
    }
}
