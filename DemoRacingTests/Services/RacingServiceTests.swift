//
//  RacingServiceTests.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation
import Testing

@testable import DemoRacing

struct RacingServiceTests {

    @Test func fetchNextRacesSuccess() async throws {
        let session = MockSession(
            data: .success(
                try #require(
                """
                {
                    "status": 200,
                    "data": {
                        "race_summaries": {
                            "25ae7360-8f2d- -95b5-91f7e802d6f7": {
                                "race_id": "25ae7360-8f2d-4533-95b5-91f7e802d6f7",
                                "race_number": 6,
                                "meeting_name": "Western Fair Raceway"
                            },
                            "5098307c-2fab-4023-a29c-0240f9b130de": {
                                "race_id": "5098307c-2fab-4023-a29c-0240f9b130de",
                                "race_number": 6,
                                "meeting_name": "Gavea"
                            },
                            "6f9569eb-fc86-43ec-8f6b-4bc5c0a785f7": {
                                "race_id": "6f9569eb-fc86-43ec-8f6b-4bc5c0a785f7",
                                "race_number": 2,
                                "meeting_name": "Yonkers Raceway"
                            }
                        }
                    }
                }
                """.data(using: .utf8))
            )
        )

        let service = RacingService(session: session)

        #expect(try await service.fetchNextRaces().count == 3)
    }

    @Test func fetchNextRacesStatus400() async throws {
        let session = MockSession(
            data: .success(
                try #require(
                """
                {
                    "status": 400,
                    "data": {
                        "race_summaries": {
                            "25ae7360-8f2d- -95b5-91f7e802d6f7": {
                                "race_id": "25ae7360-8f2d-4533-95b5-91f7e802d6f7",
                                "race_number": 6,
                                "meeting_name": "Western Fair Raceway"
                            }
                        }
                    }
                }
                """.data(using: .utf8))
            )
        )

        let service = RacingService(session: session)

        await #expect(throws: ServiceError.serverError(statusCode: 400)) {
            try await service.fetchNextRaces()
        }
    }

    @Test func fetchNextRacesError() async throws {
        let session = MockSession(data: .failure(ServiceError.invalidURL))
        let service = RacingService(session: session)
        
        await #expect(throws: ServiceError.invalidURL) {
            try await service.fetchNextRaces()
        }
    }

}
