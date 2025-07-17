//
//  MockService.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 29/6/25.
//

import Foundation

struct MockService: Servicing {
    func getProjects() async throws -> [Project] {
        return Project.mockProjectsData
    }
    
    func getReports(for projectID: Int) async throws -> [Report] {
        return Report.mockReportsData
    }
    
    func getUsers() async throws -> [User] {
        return User.mockUsers
    }
    
    func getPosts(for userID: Int) async throws -> [Post] {
        return Post.mockPosts
    }
    
    func fetchPopularMovies(page: Int) async throws -> PopularMovieResponse {
        return PopularMovieResponse.mockPopulerMovieData
    }
}

class MockServiceError: Servicing {
    func fetchPopularMovies(page: Int) async throws -> PopularMovieResponse {
        throw RequestError.invalidURL
    }
    
    func getPosts(for userID: Int) async throws -> [Post] {
        throw RequestError.emptyResponse
    }
    
    func getProjects() async throws -> [Project] {
        throw RequestError.unauthorized
    }
    
    func getReports(for projectId: Int) async throws -> [Report] {
        throw RequestError.noResponse
    }
    
    func getUsers() async throws -> [User] {
        throw RequestError.curruptData
    }
    
}

class MockEmptyData: Servicing {
    func fetchPopularMovies(page: Int) async throws -> PopularMovieResponse {
        throw RequestError.emptyResponse
    }
    
    func getUsers() async throws -> [User] {
        return []
    }
    
    func getPosts(for userID: Int) async throws -> [Post] {
        return []
    }
    
    func getProjects() async throws -> [Project] {
        return []
    }
    
    func getReports(for projectId: Int) async throws -> [Report] {
        return []
    }
}
