//
//  RacingService.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

protocol RacingServiceProtocol {

    func fetchNextRacesByCategory(_ categories: Set<RaceSummary.Category>, count: Int) async throws -> [RaceSummary]

}

struct RacingService: RacingServiceProtocol {

    private let session: SessionProtocol

    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchNextRacesByCategory(_ categories: Set<RaceSummary.Category>, count: Int) async throws -> [RaceSummary] {
        guard let url = Endpoint.nextRaces(categories: Array(categories), count: count).url else {
            throw ServiceError.invalidURL
        }

        let (data, _) = try await session.data(for:
            URLRequest(
                url: url,
                headers: [
                    .init(
                        name: HTTPHeaderField.contentType,
                        value: HTTPHeaderContentType.json
                    )
                ]
            )
        )

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(NextRacesCategoryGroupResponse.self, from: data)

        return response.summaries.map { $0.value }
    }

}
