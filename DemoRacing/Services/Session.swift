//
//  Session.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 23/10/2024.
//

import Foundation

protocol SessionProtocol {

    func data(for request: URLRequest) async throws -> (Data, URLResponse)

}

extension URLSession: SessionProtocol {}
