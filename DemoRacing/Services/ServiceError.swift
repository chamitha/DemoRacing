//
//  ServiceError.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

enum ServiceError: Error, Equatable {
    case invalidURL
    case serverError(statusCode: Int)
}
