//
//  PostsView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import Foundation
import SwiftUI

struct PostsView: View {
    
    @StateObject var viewModel: PostsViewModel
    
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: PostsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.posts) { posts in
            VStack(alignment: .leading) {
                Text(posts.title)
                    .font(.title)
                Text(posts.body)
                    .font(.caption)
            }
        }
        .onChange(of: viewModel.errorDetails) { _, newValue in
            if newValue != nil {
                showErrorAlert = true
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.errorDetails ?? "")
                .foregroundStyle(.red)
        }
        .navigationTitle("Posts")
        .onAppear {
            if viewModel.posts.isEmpty {
                Task {
                    await viewModel.getPosts()
                }
            }
        }
        .networkAlert()
    }
}
