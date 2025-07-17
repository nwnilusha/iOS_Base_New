//
//  Servicing.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

protocol Servicing {
    func fetchPopularMovies(page: Int) async throws -> PopularMovieResponse
    func getUsers() async throws -> [User]
    func getPosts(for userID: Int) async throws -> [Post]
    func getProjects() async throws -> [Project]
    func getReports(for projectId: Int) async throws -> [Report]
}
