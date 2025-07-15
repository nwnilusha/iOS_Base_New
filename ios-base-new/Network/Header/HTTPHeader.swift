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
            let populerMoviesAccessToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OWJkYjdiMGMwYmU4NTRmYmUxMTgxMjM2NjA0YTI5OSIsIm5iZiI6MTc1MDg0MzU0Mi45MzUwMDAyLCJzdWIiOiI2ODViYzA5Njk0YzRlNTc5MGVlNDJlZWEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.07zropRonVCdb_rXjQ61Z0mcFEa-R_w_16lCtZQhYHk"
            let builder = HTTPHeaderBuilder(accessToken: populerMoviesAccessToken)
            return builder.headers
        }
    }
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
