//
//  MovieEndpoint.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

enum MovieEndpoint: Endpoint {
    case popularMovies(Int)
    case userList
    case postList(Int)
    
    var scheme: String {
        switch self {
        case .popularMovies:
            return "https"
        case .userList:
            return "https"
        case .postList:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .popularMovies:
            return "api.themoviedb.org"
        case .userList:
            return "jsonplaceholder.typicode.com"
        case .postList:
            return "jsonplaceholder.typicode.com"
        }
    }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        case .userList:
            return "/users"
        case .postList(let userId):
            return "/users/\(userId)/posts"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .popularMovies:
            return .get
        case .userList:
            return .get
        case .postList:
            return .get
        }
    }
    
    var header: HTTPHeader? {
        switch self {
        case .popularMovies:
            return HTTPHeader.popuperMovies
        case .userList:
            return nil
        case .postList:
            return nil
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .popularMovies(let page):
           return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .userList:
            return nil
        case .postList:
            return nil
        }
    }
}



