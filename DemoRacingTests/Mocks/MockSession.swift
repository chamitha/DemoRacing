//
//  MockSession.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

@testable import DemoRacing

class MockSession: SessionProtocol {

    private let data: Result<Data, Error>

    init(data: Result<Data, Error>) {
        self.data = data
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try (data.get(), URLResponse())
    }

}
