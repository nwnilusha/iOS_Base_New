//
//  Constants.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 16/7/25.
//

import Foundation

struct Constants {
    static let baseImageURL = "https://image.tmdb.org/t/p/w92"
}


enum CacheKey {
    static let allMoviesCacheKey = "AllPopulerMoviesKey" as NSString
    static let allMoviesPageCacheKey = "AllPopulerMoviesPageKey" as NSString
    static let userCacheKey = "user_list_cache" as NSString
}
