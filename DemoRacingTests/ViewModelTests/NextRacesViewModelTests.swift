//
//  FooTests.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 25/10/2024.
//

import Combine
import XCTest

@testable import DemoRacing

final class NextRacesViewModelTests: XCTestCase {

    private var timer: MockTimer!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        timer = MockTimer()
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    @MainActor
    func testFetchRaces() async throws {
        // GIVEN fetching races is successful
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: Date.distantFuture),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        // WHEN the view model is initialized
        let viewModel = NextRacesViewModel(service: service, timer: timer)

        // THEN the next races are fetched
        viewModel.$filteredRaces
            .dropFirst()
            .sink {
                XCTAssertEqual($0.count, 2)
                expectation.fulfill()

            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)
    }

    @MainActor
    func testFilterExpiredRaces() async throws {
        // GIVEN fetching races is successful
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: Date.now.addingTimeInterval(60)),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "3", raceNumber: 3, meetingName: "Kilmore", category: .horse, startDate: Date.distantFuture)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        let viewModel = NextRacesViewModel(service: service, timer: timer)

        viewModel.$allRaces
            .dropFirst()
            .first()
            .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [unowned self] _ in
                // WHEN the timer fires
                // where no races have started
                timer.subject.send(Date.now)
                // where 1 race has started over 1 minute ago
                timer.subject.send(Date.now.addingTimeInterval(120))
            }
            .store(in: &cancellables)

        let expectedCount = [3, 2, 2]
        var racesCount: [Int] = []
        viewModel.$filteredRaces
            .dropFirst()
            .sink {
                racesCount.append($0.count)
                if racesCount.count == expectedCount.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        // THEN the started race is filtered
        XCTAssertEqual(racesCount, expectedCount)
    }

    @MainActor
    func testFilterByCategory() async throws {
        // GIVEN fetching races is successful
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: Date.now),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        let viewModel = NextRacesViewModel(service: service, timer: timer)

        viewModel.$allRaces
            .dropFirst()
            .first()
            .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { _ in
                // WHEN categories are selected
                viewModel.selectedCategories = [.greyhound]
                viewModel.selectedCategories = [.horse]
                viewModel.selectedCategories = [.greyhound, .horse]
            }
            .store(in: &cancellables)

        let expectedRaces = [["1", "2"], ["1"], ["2"], ["1", "2"]]
        var filteredRaces: [[String]] = []
        viewModel.$filteredRaces
            .dropFirst()
            .sink {
                filteredRaces.append($0.map(\.raceId))
                if filteredRaces.count == expectedRaces.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        // THEN the races are filtered
        XCTAssertEqual(filteredRaces, expectedRaces)
    }

    @MainActor
    func testSorting() async throws {
        // GIVEN fetching races is successful
        let startDate = Date.now
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: startDate),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "3", raceNumber: 3, meetingName: "Kilmore", category: .greyhound, startDate: startDate)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        let viewModel = NextRacesViewModel(service: service, timer: timer)

        var filteredRaces: [String] = []
        viewModel.$filteredRaces
            .dropFirst()
            .sink {
                filteredRaces = $0.map(\.raceId)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        // THEN the races are sorted by start time and meeting name
        XCTAssertEqual(filteredRaces, ["3", "1", "2"])
    }


    @MainActor
    func testMaxRaceCount() async throws {
        // GIVEN fetching races is successful
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: Date.distantFuture),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "3", raceNumber: 3, meetingName: "Kilmore", category: .greyhound, startDate: Date.distantFuture),
                    .init(raceId: "4", raceNumber: 4, meetingName: "Urawa", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "5", raceNumber: 5, meetingName: "Addington Extra", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "6", raceNumber: 6, meetingName: "Kasamatsu", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "7", raceNumber: 7, meetingName: "Sonoda", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "8", raceNumber: 8, meetingName: "Mildura", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "9", raceNumber: 9, meetingName: "Hawkesbury", category: .horse, startDate: Date.distantFuture)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        let viewModel = NextRacesViewModel(service: service, timer: timer)

        var raceCount = 0
        viewModel.$filteredRaces
            .dropFirst()
            .sink {
                raceCount = $0.count
                expectation.fulfill()
            }
            .store(in: &cancellables)



        await fulfillment(of: [expectation], timeout: 1)

        // THEN 5 races are selected
        XCTAssertEqual(raceCount, 5)
    }

    @MainActor
    func testLoading() async throws {
        // GIVEN fetching races is successful
        let service = MockRacingService(
            response: .success(
                [
                    .init(raceId: "1", raceNumber: 1, meetingName: "Western Fair Raceway", category: .greyhound, startDate: Date.distantFuture),
                    .init(raceId: "2", raceNumber: 2, meetingName: "Gavea", category: .horse, startDate: Date.distantFuture),
                    .init(raceId: "3", raceNumber: 3, meetingName: "Kilmore", category: .horse, startDate: Date.distantFuture)
                ]
            )
        )

        let expectation = expectation(description: "Fetch next races")

        // WHEN the view model is initialized
        let viewModel = NextRacesViewModel(service: service, timer: timer)

        let expectedLoading = [true, false]
        var isLoading: [Bool] = []
        viewModel.$isLoading
            .sink {
                isLoading.append($0)
                if isLoading.count == expectedLoading.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        // THEN the loading state is set
        XCTAssertEqual(isLoading, expectedLoading)
    }

    @MainActor
    func testError() async throws {
        // GIVEN fetching races fails
        let service = MockRacingService(response: .failure(ServiceError.serverError(statusCode: 400)))

        let expectation = expectation(description: "Fetch next races")

        // WHEN the view model is initialized
        let viewModel = NextRacesViewModel(service: service, timer: timer)

        let expectedLoadingState: [NextRacesViewModel.LoadingState] = [NextRacesViewModel.LoadingState.loading, NextRacesViewModel.LoadingState.error(ErrorViewModel(error: ServiceError.serverError(statusCode: 400)))]
        var loadingState: [NextRacesViewModel.LoadingState] = []
        viewModel.$loadingState
            .sink {
                loadingState.append($0)
                if loadingState.count == expectedLoadingState.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        // THEN the loading state is error
        XCTAssertEqual(loadingState, expectedLoadingState)
    }

}
