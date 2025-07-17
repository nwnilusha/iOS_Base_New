//
//  MockPopulerMovieData.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 29/6/25.
//

import Foundation

extension PopularMovieResponse {
    static var mockPopulerMovieData: PopularMovieResponse {
        Bundle.main.decode(PopularMovieResponse.self, from: "mock_populer_movie_response.json")
    }
}
