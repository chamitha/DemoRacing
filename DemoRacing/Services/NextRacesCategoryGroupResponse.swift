//
//  NextRacesCategoryGroupResponse.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct NextRacesCategoryGroupResponse: Decodable {

    public var summaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case summaries = "race_summaries"
    }

}
