//
//  Service.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation

struct Service: Servicing {
    
    private let httpService: HTTPService
    
    init(service: HTTPService) {
        self.httpService = service
    }
    
    func fetchPopularMovies(page: Int) async throws -> PopulerMovieResponse {
        DebugLogger.shared.log("Fetching popular movies. Page: \(page)")
        do {
            let response = try await httpService.sendRequest(
                session: URLSession.shared,
                endpoint: MovieEndpoint.popularMovies(page),
                responseModel: PopulerMovieResponse.self
            )
            DebugLogger.shared.log("Successfully fetched popular movies: \(response.movies.count) movies.")
            return response
        } catch {
            DebugLogger.shared.log("Error fetching popular movies: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getUsers() async throws -> [User] {
        DebugLogger.shared.log("Fetching users...")
        do {
            let users = try await httpService.sendRequest(
                session: URLSession.shared,
                endpoint: MovieEndpoint.userList,
                responseModel: [User].self
            )
            DebugLogger.shared.log("Fetched \(users.count) users.")
            return users
        } catch {
            DebugLogger.shared.log("Error fetching users: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getPosts(for userID: Int) async throws -> [Post] {
        DebugLogger.shared.log("Fetching posts for userID: \(userID)")
        do {
            let posts = try await httpService.sendRequest(
                session: URLSession.shared,
                endpoint: MovieEndpoint.postList(userID),
                responseModel: [Post].self
            )
            DebugLogger.shared.log("Fetched \(posts.count) posts for user \(userID).")
            return posts
        } catch {
            DebugLogger.shared.log("Error fetching posts for user \(userID): \(error.localizedDescription)")
            throw error
        }
    }
    
    func getProjects() async throws -> [Project] {
        DebugLogger.shared.log("Returning mock projects data.")
        return Project.mockProjectsData
    }
    
    func getReports(for projectId: Int) async throws -> [Report] {
        DebugLogger.shared.log("Filtering reports for project ID: \(projectId)")
        let allReports = Report.mockReportsData
        let filtered = allReports.filter { $0.projectId == projectId }
        DebugLogger.shared.log("Found \(filtered.count) reports for project ID: \(projectId)")
        return filtered
    }
}

