//
//  RaceSummary.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct RaceSummary: Decodable {

    var raceId: String
    var raceNumber: Int
    var meetingName: String

    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceNumber = "race_number"
        case meetingName = "meeting_name"
    }

}
