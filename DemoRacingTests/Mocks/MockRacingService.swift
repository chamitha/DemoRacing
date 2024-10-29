//
//  MockRacingService.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Foundation
import Combine

@testable import DemoRacing

struct MockRacingService: RacingServiceProtocol {

    private let response: Result<[RaceSummary], Error>

    init(response: Result<[RaceSummary], Error>) {
        self.response = response
    }

    func fetchNextRacesByCategory(_ categories: Set<RaceSummary.Category>, count: Int) async throws -> [RaceSummary] {
        try response.get()
    }

}
