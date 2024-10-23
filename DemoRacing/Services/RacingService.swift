//
//  RacingService.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct RacingService {

    enum Method: String, CaseIterable {
        case nextRaces = "nextraces"
    }

    private let session: Session

    init(session: Session = URLSession.shared) {
        self.session = session
    }

    func fetchNextRaces(_ count: Int = 10) async throws -> [RaceSummary] {
        guard let url = Endpoint.racing(method: Method.nextRaces, count: count).url else {
            throw ServiceError.invalidURL
        }

        let (data, _) = try await session.data(from: url, delegate: nil)

        let response = try JSONDecoder().decode(NextRacesResponse.self, from: data)

        guard response.status == 200 else {
            throw ServiceError.serverError(statusCode: response.status)
        }

        return response.data.summaries.map { $0.value }
    }

}

extension Endpoint {

    static func racing(method: RacingService.Method, count: Int) -> Endpoint {
        return Endpoint(
            path: "/racing/",
            queryItems: [
                URLQueryItem(name: "method", value: method.rawValue),
                URLQueryItem(name: "count", value: String(count))
            ]
        )
    }

}
