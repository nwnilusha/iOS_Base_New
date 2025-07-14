//
//  MockPopulerMovieData.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 29/6/25.
//

import Foundation

extension PopulerMovieResponse {
    static var mockPopulerMovieData: PopulerMovieResponse {
        Bundle.main.decode(PopulerMovieResponse.self, from: "mock_populer_movie_response.json")
    }
}
