//
//  UsersViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import SwiftUICore

class UsersViewModel: ObservableObject {
    private let dataService: Servicing
    private static let usersCache = NSCache<NSString, NSArray>()

    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    init(service: Servicing) {
        self.dataService = service
    }

    @MainActor
    func loadData() async {
        
        DebugLogger.shared.log("UsersViewModel - loadData started")
        
        if let cachedUsers = Self.usersCache.object(forKey: CacheKey.userCacheKey as NSString) as? [User] {
            DebugLogger.shared.log("Loaded users from cache: \(cachedUsers.count) items")
            self.users = cachedUsers
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            DebugLogger.shared.log("Fetching users from network")
            let fetchedUsers = try await dataService.getUsers()
            users = fetchedUsers
            DebugLogger.shared.log("Fetched users: \(fetchedUsers.count) items")
            Self.usersCache.setObject(fetchedUsers as NSArray, forKey: CacheKey.userCacheKey as NSString)
        } catch {
            if let apiError = error as? RequestError {
                errorMessage = apiError.errorDiscription
                DebugLogger.shared.log("User fetch failed with RequestError: \(apiError.errorDiscription)")
            } else {
                errorMessage = "Unknown error occurred"
                DebugLogger.shared.log("User fetch failed with unknown error: \(error.localizedDescription)")
            }
        }
    }
    
    func clearCache() {
        Self.usersCache.removeAllObjects()
        DebugLogger.shared.log("Users cache cleared")
    }
}


