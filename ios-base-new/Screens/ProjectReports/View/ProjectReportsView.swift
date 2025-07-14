//
//  ReportsView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import SwiftUI
import SwiftData

struct ProjectReportsView: View {
    
    @StateObject var viewModel: ProjectReportsViewModel
    @StateObject var reportViewModel: ReportSwiftDataViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddReport: Bool = false
    
    init(viewModel: ProjectReportsViewModel, reportViewModel: ReportSwiftDataViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _reportViewModel = StateObject(wrappedValue: reportViewModel)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Project Reports")
                .font(.headline)
                .foregroundColor(.black)
            
            SearchBar(searchText: $viewModel.searchedText, searchTextPlaceholder: "Search Report")
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.searchedReports) { report in
                        reportCell(for: report as (any ReportDisplayable))
                            .onTapGesture {
                                coordinator.push(.ReportDetails(report))
                            }
                    }
                    ForEach(reportViewModel.filteredReports) { report in
                        SwipeToDeleteCell(item: report, viewModel: reportViewModel) {
                            reportCell(for: report as any ReportDisplayable)
                                .onTapGesture {
                                    coordinator.push(.DatabaseReportDetails(report))
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showAddReport){
            addReportSheet(viewModel: reportViewModel, projectId: viewModel.projectId)
        }
        .toolbar {
            Button("Add Report", systemImage: "plus"){
                showAddReport = true
            }
        }
        .task {
            await viewModel.fetchReports()
            reportViewModel.filterReports(modelContext: modelContext,projectId: viewModel.projectId)
        }
    }
}

@ViewBuilder
private func reportCell(for report: any ReportDisplayable) -> some View {
    VStack(alignment: .leading, spacing: 6) {
        HStack {
            Text("Title: \(report.title)")
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(report.status)
                .font(.caption)
                .foregroundColor(report.status == "Approved" ? .green : .orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        
        Text("Inspector: \(report.inspector)")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        Text("Date: \(report.date)")
            .font(.caption)
            .foregroundColor(.gray)
        
        if !report.notes.isEmpty {
            Text("Notes: \(report.notes)")
                .font(.footnote)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .cornerRadius(16)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color(.lightGray), lineWidth: 1)
    )
    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
}

struct addReportSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ReportSwiftDataViewModel
    
    let projectId: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $viewModel.title)
                    if let error = viewModel.titleError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                Section(header: Text("Inspector")) {
                    TextField("Enter inspector name", text: $viewModel.inspector)
                    if let error = viewModel.inspectorError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $viewModel.status) {
                        Text("Pending").tag("Pending")
                        Text("Approved").tag("Approved")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 100)
                    if let error = viewModel.notesError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("New Report")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveReport(modelContext: modelContext, dismiss: dismiss,projectId: projectId)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ProjectReportsView(viewModel: ProjectReportsViewModel())
//}
