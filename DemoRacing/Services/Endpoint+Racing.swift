//
//  Endpoint+Racing.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Foundation

extension Endpoint {

    private struct Path {
        static let nextRaces = "/v2/racing/next-races-category-group"
    }

    private struct QueryItem {
        static let count = "count"
        static let categories = "categories"
    }

    static func nextRaces(categories: [RaceSummary.Category], count: Int) -> Endpoint {
        Endpoint(
            path: Path.nextRaces,
            queryItems: [
                .init(
                    name: QueryItem.count,
                    value: String(count)
                ),
                .init(
                    name: QueryItem.categories,
                    value: String(categories)
                )
            ]
        )
    }

}

private extension String {

    init(_ categories: [RaceSummary.Category]) {
        self.init("[" + categories.map { "\"" + $0.rawValue + "\"" }.joined(separator: ",") + "]")
    }

}
