//
//  Project.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import SwiftData

@Model
class ProjectModel: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var location: String
    var startDate: String

    init(id: Int, name: String, location: String, startDate: String) {
        self.id = id
        self.name = name
        self.location = location
        self.startDate = startDate
    }
}
