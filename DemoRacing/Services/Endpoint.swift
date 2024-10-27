//
//  Endpoint.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

struct Endpoint {

    let path: String
    let queryItems: [URLQueryItem]

    private let baseURL = "https://api.neds.com.au"

    var url: URL? {
        return URL(string: baseURL)?
            .appendingPathComponent(path)
            .appending(queryItems: queryItems)
    }

}
