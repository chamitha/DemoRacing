//
//  ErrorViewModelTests.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 29/10/2024.
//

import Foundation
import Testing

@testable import DemoRacing

struct ErrorViewModelTests {

    @Test func genericMessage() {
        let viewModel = ErrorViewModel(error: ServiceError.invalidURL)

        #expect(viewModel.message == "An error occurred fetching the next races.")
    }

    @Test func noInternetConnectionMessage() {
        let viewModel = ErrorViewModel(error: URLError(.notConnectedToInternet))

        #expect(viewModel.message == "The operation couldn’t be completed. (NSURLErrorDomain error -1009.)")
    }

}
