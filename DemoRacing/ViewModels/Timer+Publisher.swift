//
//  Timer+Publisher.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Combine
import Foundation

protocol TimerProtocol {

    var publisher: AnyPublisher<Date, Never> { get }

}

extension Timer.TimerPublisher: TimerProtocol {

    var publisher: AnyPublisher<Date, Never> {
        self
            .autoconnect()
            .eraseToAnyPublisher()
    }

}
