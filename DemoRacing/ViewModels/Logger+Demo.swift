//
//  Logger+Demo.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Foundation
import OSLog

extension Logger {

    init(category: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            self.init()
            return
        }
        self.init(subsystem: bundleIdentifier, category: category)
    }

}
