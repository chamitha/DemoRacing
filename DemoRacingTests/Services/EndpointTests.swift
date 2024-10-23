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

    @Test(.tags(.racing), arguments: RacingService.Method.allCases)
    func endpointURL(method: RacingService.Method) async throws {
        #expect(Endpoint.racing(method: method, count: 10).url == URL(string: "https://api.neds.com.au/rest/v1/racing/?method=\(method.rawValue)&count=10"))
    }

}

extension Tag {
    @Tag static var racing: Self
}
