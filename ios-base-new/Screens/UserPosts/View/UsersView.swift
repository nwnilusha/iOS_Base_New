//
//  UsersView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 11/7/25.
//

import SwiftUI

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel: UsersViewModel
    @EnvironmentObject var coodinator: AppCoordinator
    
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: UsersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Spacer().frame(height: 16)
                ForEach(viewModel.users) { user in
                    UserView(user: user.name, userName: user.username)
                        .onTapGesture {
                            coodinator.push(.posts(user.id))
                        }
                }
                Spacer().frame(height: 16)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                showErrorAlert = true
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
                .foregroundStyle(Color.red)
        }
        .navigationTitle("User List")
        .task {
            await viewModel.loadData()
        }
        .networkAlert()
    }
}


struct UserView: View {
    
    let user: String
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(user)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(userName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}
