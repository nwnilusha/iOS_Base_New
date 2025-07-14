//
//  AppCoordinator.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 30/6/25.
//

import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    let httpService = HTTPService()
    
    func buildDestination(for route: Routes) -> some View {
        switch route {
        case .populerMoviesView:
            let service = Service(service: httpService)
            let vm = PopulerMoviesViewModel(service: service)
            return AnyView(PopulerMoviesView(viewModel: vm))
        case .populerMovieDetails(let movieDetails):
            return AnyView(PopulerMovieDetailsView(movieDetails: movieDetails))
        case .users:
            let service = Service(service: httpService)
            let vm = UsersViewModel(service: service)
            return AnyView(UsersView(viewModel: vm))
        case .posts(let userId):
            let service = Service(service: httpService)
            let vm = PostsViewModel(service: service, userId: userId)
            return AnyView(PostsView(viewModel: vm))
        case .projects:
            let service = Service(service: httpService)
            let vm = ProjectsViewModel(service: service)
            return AnyView(ProjectsView(viewModel: vm))
        case .projectReports(let projectId):
            let service = Service(service: httpService)
            let vm = ProjectReportsViewModel(service: service, projectId: projectId)
            let swiftDataVM = ReportSwiftDataViewModel()
            return AnyView(ProjectReportsView(viewModel: vm, reportViewModel: swiftDataVM))
        case .ReportDetails(let report):
            return AnyView(ReportDetailView(report: report as (any ReportDisplayable)))
        case .DatabaseReportDetails(let report):
            return AnyView(ReportDetailView(report: report as (any ReportDisplayable)))
        case .Debugger:
            return AnyView(DebugView())
        }
    }
    
    func push(_ route:Routes){
        path.append(route)
    }
    
    func reset(){
        path = NavigationPath()
    }
}
