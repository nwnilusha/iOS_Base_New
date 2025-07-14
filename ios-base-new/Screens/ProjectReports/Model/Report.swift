//
//  Report.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation

struct Report: ReportDisplayable, Decodable, Identifiable, Hashable {
    let id: Int
    let projectId: Int
    let title: String
    let status: String
    let inspector: String
    let date: String
    let notes: String
}
