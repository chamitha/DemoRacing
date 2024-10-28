//
//  NextRacesList.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 24/10/2024.
//

import SwiftUI

import Combine

struct NextRacesList: View {

    @StateObject private var viewModel = NextRacesViewModel()

    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().eraseToAnyPublisher()

    var body: some View {
        NavigationStack {
            RaceCategoryTagList(
                categories: [.greyhound, .harness, .horse],
                selectedCategories: $viewModel.selectedCategories
            )
            if viewModel.isLoading {
                ProgressView()
            }
            if let fooError = viewModel.fooError {
                Text(fooError.message)
                Button("Retry") {
                    viewModel.fetchRaces()
                }
            }
            List(viewModel.filteredRaces) {
                NextRaceRow(race: $0, timer: timer)
            }
            .navigationTitle("Next To Go Racing")
        }
    }

}

#Preview {
    NextRacesList()
}
