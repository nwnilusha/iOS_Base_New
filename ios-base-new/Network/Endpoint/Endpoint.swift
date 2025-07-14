//
//  Endpoint.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: HTTPHeader? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}
