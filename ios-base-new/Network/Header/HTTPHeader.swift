//
//  HTTPHeader.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

enum HTTPHeader {
    case popuperMovies
    
    var headers: [String: String] {
        switch self {
        case .popuperMovies:
            let builder = HTTPHeaderBuilder(accessToken: Self.populerMoviesAccessToken)
            return builder.headers
        }
    }
    
    static let populerMoviesAccessToken: String = {
        guard let apiKey = Bundle.main.infoDictionary?["PopulerMoviesBearerToken"] as? String else {
            fatalError("POPULER_MOVIES_BEARER_TOKEN not found in Info.plist. Ensure it's set in build settings.")
        }
        return apiKey
    }()
    
}

struct HTTPHeaderBuilder {
    var headers = [String: String]()
    
    private struct Constants {
        static let application = "application/json"
    }
    
    private struct Keys {
        static let accept = "Accept"
        static let authorization = "Authorization"
    }
    
    init(accessToken: String){
        headers = [
            Keys.accept: Constants.application,
            Keys.authorization: "Bearer \(accessToken)"
        ]
    }
}
