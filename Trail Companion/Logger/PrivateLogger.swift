//
//  PrivateLogger.swift
//  Trail Companion
//
//  Created by Thomas Mary on 29/09/2023.
//

import Foundation
import OSLog

extension Logger {
    /// Using the bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    
    /// All logs related to files.
    static let files = Logger(subsystem: subsystem, category: "files")
}
