//
//  ReportDetailView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 12/7/25.
//

import SwiftUI

struct ReportDetailView: View {
    let report: any ReportDisplayable

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox(label: Label("Title", systemImage: "doc.text")) {
                    Text(report.title)
                        .font(.body)
                }

                GroupBox(label: Label("Inspector", systemImage: "person")) {
                    Text(report.inspector)
                        .font(.body)
                }

                GroupBox(label: Label("Date", systemImage: "calendar")) {
                    Text(report.date)
                        .font(.body)
                }

                GroupBox(label: Label("Status", systemImage: "checkmark.seal")) {
                    Text(report.status)
                        .font(.body)
                        .foregroundColor(report.status == "Approved" ? .green : .orange)
                }

                GroupBox(label: Label("Notes", systemImage: "note.text")) {
                    Text(report.notes)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

