//
//  EndpointTests.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation
import Testing

@testable import DemoRacing

struct EndpointTests {

    @Test(.tags(.racing))
    func nextRacesEndpointURL() async throws {
        #expect(Endpoint.nextRaces(categories: [.greyhound, .harness, .horse], count: 10).url == URL(string:  "https://api.neds.com.au/v2/racing/next-races-category-group?count=10&categories=%5B%229daef0d7-bf3c-4f50-921d-8e818c60fe61%22,%22161d9be2-e909-4326-8c2c-35ed71fb460b%22,%224a2788f8-e825-4d36-9894-efd4baf1cfae%22%5D"))
    }

}

extension Tag {
    @Tag static var racing: Self
}
