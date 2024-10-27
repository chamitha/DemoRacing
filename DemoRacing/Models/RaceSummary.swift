//
//  RaceSummary.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct RaceSummary: Decodable, Equatable {

    enum Category: String, Decodable, CaseIterable {
        case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
        case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    }

    var raceId: String
    var raceNumber: Int
    var meetingName: String
    var category: Category
    var startDate: Date

    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceNumber = "race_number"
        case meetingName = "meeting_name"
        case category = "category_id"
        case startDate = "advertised_start"
    }

}
