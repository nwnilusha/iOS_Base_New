//
//  MockUsersPosts.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 14/7/25.
//

import Foundation

extension User {
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "mock_users.json")
    }
}

extension Post {
    static var mockPosts: [Post] {
        Bundle.main.decode([Post].self, from: "mock_posts.json")
    }
}
