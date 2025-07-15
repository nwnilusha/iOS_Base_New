//
//  PopulerMoviesViewModel.swift
//  ios-base-new
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import Foundation
import Combine

class PopulerMoviesViewModel: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var populerMovies: [Movie]?
    @Published var requestError: String?
    @Published var searchedText: String = ""
    @Published var pageNumber: Int = 1
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    
    private static let populerMovieCache = NSCache<NSString, NSArray>()
    private static let populerMociePageCache = NSCache<NSString, NSNumber>()
    
    let allMoviesCacheKey = "AllPopulerMoviesKey" as NSString
    let allMoviesPageCacheKey = "AllPopulerMoviesPageKey" as NSString
    
    private var cancelable = Set<AnyCancellable>()
    
    private let service: Servicing
    
    init(service: Servicing) {
        self.service = service
        populerMovieSearch()
        DebugLogger.shared.log("PopulerMoviesViewModel initialized")
    }
    
    @MainActor
    func loadInitialData() async {
        DebugLogger.shared.log("Loading initial data")
        
        if let _ = self.movies {
            DebugLogger.shared.log("Movies already loaded in memory, skipping fetch")
            return
        } else if let cacheMovies = Self.populerMovieCache.object(forKey: allMoviesCacheKey) as? [Movie],
                  let cachePageNumber = Self.populerMociePageCache.object(forKey: allMoviesPageCacheKey) as? Int {
            self.movies = cacheMovies
            self.pageNumber = cachePageNumber
            self.populerMovies = cacheMovies
            DebugLogger.shared.log("Loaded movies from cache (Page \(cachePageNumber))")
        } else {
            await fetchPopularMovies()
        }
    }
    
    @MainActor
    func fetchPopularMovies() async {
        guard !isLoading else {
            DebugLogger.shared.log("Fetch aborted — already loading")
            return
        }
        
        isLoading = true
        DebugLogger.shared.log("Started fetching movies for page: \(pageNumber)")
        defer {
            isLoading = false
        }
        
        do {
            let movieData = try await service.fetchPopularMovies(page: pageNumber)
            DebugLogger.shared.log("Fetched \(movieData.movies.count) movies from service")
            
            if self.movies == nil {
                self.movies = movieData.movies
            } else {
                movieData.movies.forEach { movie in
                    if !(self.movies?.contains(where: { $0.title == movie.title }) ?? false) {
                        self.movies?.append(movie)
                    }
                }
            }
            
            if let allMovies = self.movies {
                self.populerMovies = allMovies
                self.pageNumber += 1
                DebugLogger.shared.log("Updated movie list (Page now: \(pageNumber))")

                Self.populerMovieCache.setObject(Array(allMovies) as NSArray, forKey: allMoviesCacheKey)
                Self.populerMociePageCache.setObject(pageNumber as NSNumber, forKey: allMoviesPageCacheKey)
                DebugLogger.shared.log("Cached \(allMovies.count) movies")
            }
            
        } catch {
            if let apiError = error as? RequestError {
                self.requestError = apiError.errorDiscription
                DebugLogger.shared.log("RequestError: \(String(describing: requestError))")
            } else {
                self.requestError = "Unknown error occurred"
                DebugLogger.shared.log("Unknown error occurred while fetching movies")
            }
        }
    }
    
    func populerMovieSearch() {
        DebugLogger.shared.log("Search pipeline started")
        
        $searchedText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                if value.isEmpty {
                    self.isSearching = false
                    self.populerMovies = self.movies
                    DebugLogger.shared.log("Search cleared — showing all movies")
                } else {
                    self.isSearching = true
                    let filtered = self.movies?.filter { $0.title.lowercased().hasPrefix(value.lowercased()) }
                    self.populerMovies = filtered
                    DebugLogger.shared.log("Search: '\(value)' — matched \(filtered?.count ?? 0) movies")
                }
            }
            .store(in: &cancelable)
    }
}

