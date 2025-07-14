//
//  ProjectViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import Combine

class ProjectsViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var filteredProjects: [Project] = []
    @Published var searchedText: String = ""
    private let service: Servicing
    
    var cancellables: Set<AnyCancellable> = []
    
    init(service: Servicing) {
        self.service = service
        filterProjects()
    }

    @MainActor
    func fetchProjects() async {
        do {
            projects = try await service.getProjects()
            self.filteredProjects = self.projects
        }
        catch {
            print("Error fetching projects: \(error)")
        }
    }
    
    func filterProjects() {
        $searchedText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.filteredProjects = self.projects
                } else {
                    self.filteredProjects = self.projects.filter { $0.name.lowercased().hasPrefix(text.lowercased())}
                }
            }
            .store(in: &cancellables)
    }
}
