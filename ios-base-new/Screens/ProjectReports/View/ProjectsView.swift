//
//  ProjectsView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import SwiftUI

struct ProjectsView: View {
    @StateObject var viewModel: ProjectsViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    init(viewModel: ProjectsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Projects")
                .font(.headline)
                .foregroundColor(.black)
            
            SearchBar(searchText: $viewModel.searchedText, searchTextPlaceholder: "Search Project")
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.filteredProjects) { project in
                        projectCell(for: project)
                            .onTapGesture {
                                coordinator.push(.projectReports(project.id))
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .task {
            await viewModel.fetchProjects()
        }
    }
}

@ViewBuilder
private func projectCell(for project: Project) -> some View {
    HStack {
        VStack(alignment: .leading, spacing: 6) {
            Text("Project Name: \(project.name)")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Location: \(project.location)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Start Date: \(project.startDate)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
            .foregroundColor(.gray)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .cornerRadius(12)
    .overlay(
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color(.lightGray), lineWidth: 1)
    )
    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
}




//#Preview {
//    ProjectsView()
//}
