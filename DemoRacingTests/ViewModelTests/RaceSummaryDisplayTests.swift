//
//  RaceSummaryDisplayTests.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 28/10/2024.
//

import Foundation
import Testing

@testable import DemoRacing

struct RaceSummaryDisplayTests {

    @Test func title() {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: Date.now
        )

        #expect(raceSummary.title == "Mildura R1")
    }

    @Test func accessibilityLabel() throws {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: Date.now.addingTimeInterval(120)
        )

        print(raceSummary.accessibilityLabel)

        #expect(try /Horses. Mildura Race 1. Starting \w+ minute, [\w-]+ seconds/.wholeMatch(in: raceSummary.accessibilityLabel) != nil)
    }

    @Test(arguments: [
        Date.now.addingTimeInterval(120),
        Date.now,
        Date.now.addingTimeInterval(-30),
    ])
    func isStartingTrue(startDate: Date) {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: startDate
        )

        #expect(raceSummary.isStarting == true)
    }

    @Test func isStartingFalse() {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: Date.now.addingTimeInterval(360)
        )

        #expect(raceSummary.isStarting == false)
    }

    @Test func formattedStartDateSeconds() throws {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: Date.now.addingTimeInterval(120)
        )

        #expect(try /\d+m \d+s./.wholeMatch(in: #require(raceSummary.formattedStartDate)) != nil)
    }

    @Test func formattedStartDateMinutes() async throws {
        let raceSummary = RaceSummary(
            raceId: "1",
            raceNumber: 1,
            meetingName: "Mildura",
            category: .horse,
            startDate: Date.now.addingTimeInterval(360)
        )

        #expect(raceSummary.formattedStartDate == "5m")
    }

}
