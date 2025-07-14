//
//  ReportSwiftDataViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 14/7/25.
//

import Foundation
import SwiftData
import SwiftUI

class ReportSwiftDataViewModel: ObservableObject {
    
    @Published var filteredReports: [ReportModel] = []
    
    @Published var title: String = ""
    @Published var inspector: String = ""
    @Published var status: String = "Pending"
    @Published var notes: String = ""
    
    @Published var titleError: String?
    @Published var inspectorError: String?
    @Published var notesError: String?
    
    func saveReport(modelContext: ModelContext, dismiss: DismissAction, projectId: Int) {
        
        guard validateInputs() else {
            return
        }
        
        let newReport = ReportModel(
            id: Int(Date().timeIntervalSince1970),
            projectId: projectId,
            title: title,
            status: status,
            inspector: inspector,
            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
            notes: notes
        )
        modelContext.insert(newReport)
        
        filterReports(modelContext:modelContext ,projectId: projectId)
        
        dismiss()
    }
    
    func filterReports(modelContext: ModelContext, projectId: Int) {
        do {
            let descriptor = FetchDescriptor<ReportModel>(
                predicate: #Predicate { report in
                    report.projectId == projectId
                },
                sortBy: [SortDescriptor(\.id)]
            )
            
            self.filteredReports = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch filtered reports: \(error)")
        }
    }
    
    func deleteReport(modelContext: ModelContext, reportDetails: ReportModel) {
        do {
            let reportIdToDelete = reportDetails.id
            let descriptor = FetchDescriptor<ReportModel>(
                predicate: #Predicate { report in
                    report.id == reportIdToDelete
                }
            )
            
            let reportsToDelete = try modelContext.fetch(descriptor)
            for report in reportsToDelete {
                modelContext.delete(report)
            }
            
            filterReports(modelContext: modelContext, projectId: reportDetails.projectId)
            
        } catch {
            print("Failed to delete report: \(error)")
        }
    }
    
    func validateInputs() -> Bool {
        var isValid = true
        
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleError = "Title cannot be empty."
            isValid = false
        } else {
            titleError = nil
        }
        
        let inspectorTrimmed = inspector.trimmingCharacters(in: .whitespacesAndNewlines)
        let lettersOnlyRegex = "^[A-Za-z ]+$"
        
        if inspectorTrimmed.isEmpty {
            inspectorError = "Inspector name cannot be empty."
            isValid = false
        } else if !NSPredicate(format: "SELF MATCHES %@", lettersOnlyRegex).evaluate(with: inspectorTrimmed) {
            inspectorError = "Only letters and spaces are allowed."
            isValid = false
        } else {
            inspectorError = nil
        }
        
        if notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notesError = "Notes cannot be empty."
            isValid = false
        } else {
            notesError = nil
        }
        
        return isValid
    }
}
