//
//  RaceSummary+Display.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 24/10/2024.
//

import Foundation

extension RaceSummary {

    var imageName: String {
        category.imageName
    }

    var title: String {
        String(localized: "\(meetingName) R\(raceNumber)")
    }

    var accessibilityLabel: String {
        let startDate = Date.RelativeFormatStyle(presentation: .named, unitsStyle: .spellOut).format(startDate)
        return String(localized: "\(category.title). \(meetingName) Race \(raceNumber), \(startDate)")
    }

    var isStarting: Bool {
        // The start time is less than 5 minutes
        startDate.timeIntervalSinceNow < 300
    }

    var formattedStartDate: String? {
        Date.RelativeFormatStyle(
            presentation: .numeric,
            unitsStyle: .abbreviated
        ).format(startDate)
    }

}

extension RaceSummary.Category {

    var title: String {
        return switch self {
        case .greyhound:
            String(localized: "Greyhounds")
        case .harness:
            String(localized: "Harness")
        case .horse:
            String(localized: "Horses")
        }
    }

    var imageName: String {
        return switch self {
        case .greyhound:
            "greyhound"
        case .harness:
            "harness"
        case .horse:
            "horse"
        }
    }

}

extension RaceSummary.Category: Identifiable {

    var id: String {
        rawValue
    }

}
