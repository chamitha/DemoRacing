//
//  URLRequest+Header.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Foundation

extension URLRequest {

    init(url: URL, headers: [HTTPHeaderItem]) {
        self.init(url: url)

        headers.forEach {
            setValue($0.value, forHTTPHeaderField: $0.name)
        }
    }

}
