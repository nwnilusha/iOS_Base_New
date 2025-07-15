//
//  PostsViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation

class PostsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorDetails: String?
    @Published var posts: [Post] = []
    
    var service: Servicing
    var userId: Int
    
    private static let postCache = NSCache<NSNumber, NSArray>()
    
    init(service: Servicing, userId: Int) {
        self.service = service
        self.userId = userId
        DebugLogger.shared.log("PostsViewModel initialized for userId: \(userId)")
    }
    
    @MainActor
    func getPosts() async {
        let cacheKey = NSNumber(value: userId)
        DebugLogger.shared.log("PostsViewModel - getPosts started for userId: \(userId)")
        
        if let cached = Self.postCache.object(forKey: cacheKey) as? [Post] {
            DebugLogger.shared.log("Loaded posts from cache: \(cached.count) items for userId: \(userId)")
            self.posts = cached
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            DebugLogger.shared.log("Fetching posts from network for userId: \(userId)")
            let fetchedPosts = try await service.getPosts(for: self.userId)
            self.posts = fetchedPosts
            DebugLogger.shared.log("Fetched posts: \(fetchedPosts.count) items for userId: \(userId)")
            Self.postCache.setObject(fetchedPosts as NSArray, forKey: cacheKey)
        } catch {
            if let apiError = error as? RequestError {
                errorDetails = apiError.errorDiscription
                DebugLogger.shared.log("User fetch failed with RequestError: \(apiError.errorDiscription)")
            } else {
                errorDetails = "Unknown error occurred"
                DebugLogger.shared.log("User fetch failed with unknown error: \(error.localizedDescription)")
            }
        }
    }
    
    func clearCache() {
        Self.postCache.removeAllObjects()
        DebugLogger.shared.log("Posts cache cleared")
    }
}

