//
//  MockTimer.swift
//  DemoRacingTests
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Combine
import Foundation

@testable import DemoRacing

class MockTimer: TimerProtocol {

    var subject = PassthroughSubject<Date, Never>()

    var publisher: AnyPublisher<Date, Never> {
        return subject
            .eraseToAnyPublisher()
    }

}
