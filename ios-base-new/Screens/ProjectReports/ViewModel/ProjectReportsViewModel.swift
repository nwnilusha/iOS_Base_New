//
//  ReportViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

class ProjectReportsViewModel: ObservableObject {
    @Published var reports: [Report] = []
    @Published var searchedReports: [Report] = []
    
    @Published var searchedText: String = ""
    
    let service: Servicing
    let projectId: Int
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: Servicing, projectId: Int) {
        self.service = service
        self.projectId = projectId
        searchReports()
    }

    @MainActor
    func fetchReports() async {
        do {
            reports = try await service.getReports(for: projectId)
            self.searchedReports = self.reports
        }
        catch {
            print("Error fetching projects: \(error)")
        }
    }
    
    func searchReports() {
        $searchedText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.searchedReports = self.reports
                } else {
                    self.searchedReports = self.reports.filter { $0.title.lowercased().hasPrefix(text.lowercased()) }
                }
            }
            .store(in: &cancellables)
    }

}
