//
//  User.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
