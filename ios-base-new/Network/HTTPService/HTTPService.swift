//
//  HTTPClient.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

struct HTTPService: HTTPServicing {
    
    func sendRequest<T: Decodable>(
        session: URLSession,
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            DebugLogger.shared.log("Invalid URL for endpoint: \(endpoint.path)")
            throw RequestError.invalidURL
        }
        
        DebugLogger.shared.log("Initiating request: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let headers = endpoint.header {
            request.allHTTPHeaderFields = headers.headers
            DebugLogger.shared.log("Request Headers: \(headers.headers)")
        }
        
        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            DebugLogger.shared.log("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "N/A")")
        }

        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DebugLogger.shared.log("No HTTP response received.")
                throw RequestError.noResponse
            }
            
            DebugLogger.shared.log("Response Code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200..<300:
                break
            case 401:
                throw RequestError.unauthorized
            case 425:
                throw RequestError.workInProgress
            default:
                throw RequestError.unexpectedStatusCode
            }
            
            guard !data.isEmpty else {
                DebugLogger.shared.log("Empty response data.")
                throw RequestError.emptyResponse
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DebugLogger.shared.log("Decoded response successfully for \(endpoint.path)")
                return decoded
            } catch {
                DebugLogger.shared.log("Decoding error: \(error.localizedDescription)")
                throw RequestError.decodingError(error.localizedDescription)
            }
            
        } catch {
            DebugLogger.shared.log("Data task failed: \(error.localizedDescription)")
            throw RequestError.dataTaskError(error.localizedDescription)
        }
    }
}


enum RequestError: Error {
    case invalidURL
    case noResponse
    case emptyResponse
    case unauthorized
    case unexpectedStatusCode
    case workInProgress
    case dataTaskError(String)
    case curruptData
    case decodingError(String)
    
    var errorDiscription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .emptyResponse:
            return "Empty Response"
        case .dataTaskError(let message):
            return message
        case .curruptData:
            return "Currupt Data"
        case .decodingError(let message):
            return message
        case .unauthorized:
            return "Unauthorized"
        case .unexpectedStatusCode:
            return "Unexpected Status Code"
        case .workInProgress:
            return "Work In Progress"
        }
    }
}
