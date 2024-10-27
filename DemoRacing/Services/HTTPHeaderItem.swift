//
//  HTTPHeaderItem.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 27/10/2024.
//

import Foundation

struct HTTPHeaderItem {
    let name: String
    let value: String?
}

struct HTTPHeaderField {
    static let contentType = "Content-Type"
}

struct HTTPHeaderContentType {
    static let json = "application/json"
}
