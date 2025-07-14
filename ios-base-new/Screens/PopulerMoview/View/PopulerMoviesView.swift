//
//  PopulerMoviesView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import SwiftUI
import Foundation

struct Constants {
    static let baseImageURL = "https://image.tmdb.org/t/p/w92"
}

struct PopulerMoviesView: View {
    
    @StateObject var viewModel: PopulerMoviesViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    @Environment(\.dismiss) private var dismiss
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    init(viewModel: PopulerMoviesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Popular Movies")
                .font(.headline)
                .foregroundColor(.black)
            
            SearchBar(searchText: $viewModel.searchedText, searchTextPlaceholder: "Search Movie")
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.populerMovies?.enumerated() ?? [].enumerated()), id: \.1.id) { index, movie in
                        movieCell(for: movie)
                            .onAppear {
                                if index == (viewModel.populerMovies?.count ?? 0) - 1 && !viewModel.isSearching {
                                    Task {
                                        await viewModel.fetchPopularMovies()
                                    }
                                }
                            }
                            .onTapGesture {
                                coordinator.push(.populerMovieDetails(movie))
                            }
                        
                    }
                }
                .padding(.horizontal)
            }
            if viewModel.isLoading {
                ProgressView()
                    .padding(.vertical)
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
        .alert("Error", isPresented: .constant(viewModel.requestError != nil)) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.requestError ?? "Unknown error")
        }
        .networkAlert()
    }
}

private func movieCell(for movie: Movie) -> some View {
    VStack(spacing: 8) {
        if let path = movie.backdropPath,
           let url = URL(string: Constants.baseImageURL + path) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    
                case .success(let image):
                    image
                        .resizable()
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(8)
                    
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(height: 100)
                        .cornerRadius(8)
                    
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Color.gray
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
        }
        
        Text(movie.title)
            .font(.caption)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(maxHeight: .infinity, alignment: .top)
    }
    .padding()
    .frame(width: 140, height: 160) // fixed container size
    .background(Color.white)
    .cornerRadius(16)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color(.lightGray), lineWidth: 1)
    )
}


//#Preview {
//    let httpService = HTTPService()
//    let service = Service(service: httpService)
//    let vm = PopulerMoviesViewModel(service: service)
//    PopulerMoviesView(viewModel: vm)
//}
