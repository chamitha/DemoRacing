//
//  NextRaceRow.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 24/10/2024.
//

import Combine
import SwiftUI

struct NextRaceRow: View {

    var race: RaceSummary
    var timer: AnyPublisher<Date, Never>

    @State private var formattedStartDate: String?

    var body: some View {
        HStack {
            Image(systemName: race.imageName)
            Text(race.title)
            Spacer()
            if let formattedStartDate {
                Text(formattedStartDate)
                    .foregroundStyle(race.isStarting ? .red : .primary)
            }
        }
        .accessibilityElement()
        .accessibilityLabel(race.accessibilityLabel)
        .onReceive(timer) { _ in
            formattedStartDate = race.formattedStartDate
        }
        .onAppear {
            formattedStartDate = race.formattedStartDate
        }
    }

}

#Preview {
    NextRaceRow(
        race: RaceSummary(
            raceId: "25ae7360-8f2d- -95b5-91f7e802d6f7",
            raceNumber: 1,
            meetingName: "Western Fair Raceway",
            category: .horse, startDate: Date().addingTimeInterval(10)
        ), timer: Just(Date.now).eraseToAnyPublisher()
    )
}
