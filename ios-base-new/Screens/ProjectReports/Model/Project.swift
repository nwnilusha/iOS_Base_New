//
//  Project.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation

struct Project: Decodable, Identifiable {
    let id: Int
    let name: String
    let location: String
    let startDate: String
}
