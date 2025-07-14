//
//  PopulerMovieDetailsView.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 30/6/25.
//

import SwiftUI

struct PopulerMovieDetailsView: View {
    
    let movieDetails: Movie
    
    var body: some View {
        VStack(spacing: 20) {
            RemoteImageView(url: URL(string: Constants.baseImageURL + (movieDetails.backdropPath ?? "")))
                .frame(width: 300, height: 300)
                .cornerRadius(8)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title: ").bold() + Text(movieDetails.title)
                Text("Language: ").bold() + Text(movieDetails.originalLanguage)
                Text("Description: ").bold() + Text(movieDetails.overview)
                Text("Popularity: ").bold() + Text(String(format: "%.1f", movieDetails.popularity))
                Text("Release Date: ").bold() + Text(movieDetails.releaseDate)
            }
            .padding()
            .foregroundColor(.primary)
        }
        .networkAlert()
    }
}


struct RemoteImageView: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    PopulerMovieDetailsView()
//}
