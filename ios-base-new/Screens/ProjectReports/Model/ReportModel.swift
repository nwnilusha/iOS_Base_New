//
//  Report.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import SwiftData

protocol ReportDisplayable: Equatable {
    var id: Int { get }
    var projectId: Int { get }
    var title: String { get }
    var inspector: String { get }
    var status: String { get }
    var date: String { get }
    var notes: String { get }
}

@Model
class ReportModel: ReportDisplayable, Identifiable {
    @Attribute(.unique) var id: Int
    var projectId: Int
    var title: String
    var status: String
    var inspector: String
    var date: String
    var notes: String

    init(id: Int, projectId: Int, title: String, status: String, inspector: String, date: String, notes: String) {
        self.id = id
        self.projectId = projectId
        self.title = title
        self.status = status
        self.inspector = inspector
        self.date = date
        self.notes = notes
    }
}
