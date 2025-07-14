//
//  SwipeToDeleteCell.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 12/7/25.
//

import SwiftUI
import SwiftData

struct SwipeToDeleteCell<Content: View>: View {
    @Environment(\.modelContext) private var modelContext
    let item: ReportModel
    let viewModel: ReportSwiftDataViewModel
    let content: () -> Content

    @State private var offsetX: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }

            content()
                .background(Color.white)
                .offset(x: offsetX + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if value.translation.width < 0 {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                offsetX = value.translation.width < -80 ? -80 : 0
                            }
                        }
                )
                .onTapGesture {
                    withAnimation {
                        offsetX = 0
                    }
                }
        }
        .animation(.spring(), value: offsetX)
        .alert("Delete Report", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    viewModel.deleteReport(modelContext: modelContext, reportDetails: item)
                }
            }
            Button("Cancel", role: .cancel) {
                withAnimation {
                    offsetX = 0
                }
            }
        } message: {
            Text("Are you sure you want to delete this report?")
        }
    }
}

