//
//  NextRacesResponse.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct NextRacesResponse: Decodable {

    struct Data: Decodable {

        var summaries: [String: RaceSummary]

        enum CodingKeys: String, CodingKey {
            case summaries = "race_summaries"
        }

    }

    public var status: Int
    public var data: Data

}
