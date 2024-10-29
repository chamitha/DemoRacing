//
//  ErrorViewModel.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 29/10/2024.
//

import Foundation

struct ErrorViewModel: Equatable {
    let message: String

    init(error: Error) {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            self.message = error.localizedDescription
        } else {
            self.message = "An error occurred fetching the next races."
        }
    }
}
