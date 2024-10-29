//
//  NextRacesViewModel.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Combine
import Foundation
import OSLog

@MainActor
class NextRacesViewModel: ObservableObject {

    enum LoadingState: Equatable {
        case loading
        case complete
        case error(ErrorViewModel)
    }

    // The maximum number of races to display
    private static let maxRaceCount = 5

    // The number of seconds after the race start that the race remains displayed
    private static let raceExpiryInterval = Duration.seconds(-60)

    // MARK: Published
    @Published private(set) var isLoading = false
    @Published var allRaces: [RaceSummary] = []
    @Published private(set) var filteredRaces: [RaceSummary] = []
    @Published var selectedCategories: Set<RaceSummary.Category> = [.greyhound, .harness, .horse]
    @Published private(set) var loadingState: LoadingState = .complete

    // MARK: Private
    private let service: RacingServiceProtocol
    private let logger = Logger(category: String(describing: NextRacesViewModel.self))
    private let timer: TimerProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(
        service: RacingServiceProtocol = RacingService(),
        timer: TimerProtocol = Timer.publish(every: 1, on: .main, in: .default)
    ) {
        self.service = service
        self.timer = timer

        fetchRaces()

        $allRaces
            .combineLatest($selectedCategories)
            .map { allRaces, selectedCategories in
                Array(allRaces
                    // Filter the races by the selected categories
                    .filter { selectedCategories.contains($0.category) }
                    // Sort the races by start date and meeting name
                    .sorted(by: <)
                    // Select the first 5 races
                    .prefix(NextRacesViewModel.maxRaceCount)
                )
            }
            .assign(to: &$filteredRaces)

        $loadingState
            .combineLatest($filteredRaces)
            .map { loadingState, filteredRaces in
                loadingState == .loading &&
                // If there are races to display the fetch can be silent
                filteredRaces.count < NextRacesViewModel.maxRaceCount
            }
            .removeDuplicates()
            .assign(to: &$isLoading)

        timer.publisher
            .sink { [unowned self] in
                // If no races and no error then fetch more races
                // If an error has occurred don't attempt to fetch races to prevent repeated failures
                // The user can retry the fetch
                if allRaces.isEmpty && loadingState == .complete {
                    fetchRaces(startDate: $0)
                    return
                }

                // If any races have expired
                if allRaces.hasExpiredRaces(startDate: $0, expiryInterval: NextRacesViewModel.raceExpiryInterval) {
                    // Remove the expired races
                    allRaces = allRaces.upcomingRaces(
                        startDate: $0,
                        expiryInterval: NextRacesViewModel.raceExpiryInterval
                    )
                    // Fetch races to replace the expired races
                   fetchRaces(startDate: $0)
               }
            }
            .store(in: &cancellables)
    }

    func fetchRaces(startDate: Date = .now) {
        // If fetch is in progress then return
        if loadingState == .loading {
            return
        }
        loadingState = .loading

        Task {
            do {
                logger.trace("Fetch next races")
                allRaces = try await service
                    .fetchNextRacesByCategory([.horse, .greyhound, .harness], count: 10)
                    .upcomingRaces(startDate: startDate, expiryInterval: NextRacesViewModel.raceExpiryInterval)
                loadingState = .complete
                logger.trace("Recieved next races: \(self.allRaces.count)")
            } catch {
                logger.error("\(error.localizedDescription)")
                loadingState = .error(ErrorViewModel(error: error))
            }
        }
    }

}

extension RaceSummary: Identifiable {

    var id: String {
        raceId
    }

}

extension RaceSummary: Comparable {

    static func == (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
        return (lhs.startDate, lhs.meetingName) ==
        (rhs.startDate, rhs.meetingName)
    }

    static func < (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
        return (lhs.startDate, lhs.meetingName) <
            (rhs.startDate, rhs.meetingName)
    }

}

extension Array where Element == RaceSummary {

    func hasExpiredRaces(startDate: Date, expiryInterval: Duration) -> Bool {
        self.contains {
            Duration.seconds($0.startDate.timeIntervalSinceNow) < expiryInterval
        }
    }

    func upcomingRaces(startDate: Date, expiryInterval: Duration) -> [RaceSummary] {
        self.filter {
            Duration.seconds($0.startDate.timeIntervalSinceNow) > expiryInterval
        }
    }

}
