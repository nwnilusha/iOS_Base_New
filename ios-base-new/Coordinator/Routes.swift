//
//  Routes.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 30/6/25.
//

import Foundation

enum Routes: Hashable {
    case populerMoviesView
    case populerMovieDetails(Movie)
    case users
    case posts(Int)
    case projects
    case projectReports(Int)
    case ReportDetails(Report)
    case DatabaseReportDetails(ReportModel)
    case Debugger
}
