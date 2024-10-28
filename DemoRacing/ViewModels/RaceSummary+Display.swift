//
//  RaceSummary+Display.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 24/10/2024.
//

import Foundation

extension RaceSummary {

    var imageName: String {
        return switch category {
        case .greyhound:
            "play"
        case .harness:
            "pause"
        case .horse:
            "stop"
        }
    }

    var title: String {
        String(localized: "\(meetingName) R\(raceNumber)")
    }

    var accessibilityLabel: String {
        guard let startDate = dateFormatter(unitsStyle: .spellOut).string(from: startDate.timeIntervalSinceNow) else {
            return String(
                localized: "\(category.title). \(meetingName) Race \(raceNumber)"
            )
        }
        return String(
            localized: "\(category.title). \(meetingName) Race \(raceNumber). Starting \(startDate)"
        )
    }

    var isStarting: Bool {
        // The start time is less than 5 minutes
        startDate.timeIntervalSinceNow < 300
    }

    var formattedStartDate: String? {
        dateFormatter().string(from: startDate.timeIntervalSinceNow)
    }

    private func dateFormatter(
        unitsStyle: DateComponentsFormatter.UnitsStyle = .abbreviated
    ) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = unitsStyle
        formatter.allowedUnits = isStarting ? [.minute, .second] : [.minute]
        formatter.allowsFractionalUnits = false
        return formatter
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

}

extension RaceSummary.Category: Identifiable {

    var id: String {
        rawValue
    }

}
