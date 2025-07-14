//
//  HTTPServicing.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

protocol HTTPServicing {
    func sendRequest<T: Decodable> (session: URLSession, endpoint: Endpoint, responseModel: T.Type) async throws -> T
}
