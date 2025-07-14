//
//  Mock_Projects_Reports.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation

extension Report {
    static var mockReportsData: [Report] {
        Bundle.main.decode([Report].self, from: "mock_report_response.json")
    }
}

extension Project {
    static var mockProjectsData: [Project] {
        Bundle.main.decode([Project].self, from: "mock_project_response.json")
    }
}
