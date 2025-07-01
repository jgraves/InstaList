//
//  Log.swift
//  InstaList
//
//  Created by Jon on 7/1/25.
//

import Foundation
import OSLog

extension Logger {
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "com.graves.jon.InstaList", category: category)
    }
}
