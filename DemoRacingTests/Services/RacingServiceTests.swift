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
                    "race_summaries": {
                        "25ae7360-8f2d- -95b5-91f7e802d6f7": {
                            "race_id": "25ae7360-8f2d-4533-95b5-91f7e802d6f7",
                            "race_number": 6,
                            "meeting_name": "Western Fair Raceway",
                            "category_id": "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
                            "advertised_start": "2024-10-24T06:12:00Z"
                        },
                        "5098307c-2fab-4023-a29c-0240f9b130de": {
                            "race_id": "5098307c-2fab-4023-a29c-0240f9b130de",
                            "race_number": 6,
                            "meeting_name": "Gavea",
                            "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                            "advertised_start": "2024-10-24T06:15:00Z"
                        },
                        "6f9569eb-fc86-43ec-8f6b-4bc5c0a785f7": {
                            "race_id": "6f9569eb-fc86-43ec-8f6b-4bc5c0a785f7",
                            "race_number": 2,
                            "meeting_name": "Yonkers Raceway",
                        "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b",
                        "advertised_start": "2024-10-24T07:33:00Z"
                        }
                    }
                }
                """.data(using: .utf8))
            )
        )

        let service = RacingService(session: session)

        #expect(try await service.fetchNextRacesByCategory([], count: 10).count == 3)
    }

    @Test func fetchNextRacesError() async throws {
        let session = MockSession(data: .failure(ServiceError.invalidURL))
        let service = RacingService(session: session)
        
        await #expect(throws: ServiceError.invalidURL) {
            try await service.fetchNextRacesByCategory([], count: 10)
        }
    }

}
