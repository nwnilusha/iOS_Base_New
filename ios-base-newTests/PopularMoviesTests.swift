//
//  PopularMoviesTests.swift
//  PopulerMoviesTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 27/6/25.
//

import XCTest
@testable import ios_base_new

final class PopularMoviesTests: XCTestCase {
    
    func test_loadInitialData_withCachedData_shouldUseCache() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)

        let movie = Movie.mockMovie(title: "Cached Movie")
        PopularMoviesViewModel.populerMovieCache.setObject([movie] as NSArray, forKey: viewModel.allMoviesCacheKey)
        PopularMoviesViewModel.populerMociePageCache.setObject(2, forKey: viewModel.allMoviesPageCacheKey)
        
        await viewModel.loadInitialData()

        XCTAssertEqual(viewModel.movies?.first?.originalTitle, "Cached Movie")
        XCTAssertEqual(viewModel.pageNumber, 2)
    }


    func test_loadInitialData_withoutCache_shouldFetchFromService() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)

        await viewModel.loadInitialData()

        XCTAssertNotNil(viewModel.movies)
        XCTAssertFalse(viewModel.movies?.isEmpty ?? true)
    }
    
    func test_searchText_shouldFilterMovies() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)
        await viewModel.fetchPopularMovies()

        viewModel.searchedText = "Oppenheimer"

        do {
            try await Task.sleep(for: .seconds(0.6))
            XCTAssertEqual(viewModel.populerMovies?.first?.title, "Oppenheimer")
            XCTAssertTrue(viewModel.isSearching)
        } catch {
            XCTFail("Error: \(error)")
        }
    }
    
    func test_searchText_empty_shouldResetToAllMovies() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)
        await viewModel.fetchPopularMovies()

        viewModel.searchedText = ""
        
        do {
            try await Task.sleep(for: .seconds(0.6))
            XCTAssertEqual(viewModel.populerMovies?.count, viewModel.movies?.count)
            XCTAssertFalse(viewModel.isSearching)
        } catch {
            XCTFail("Error: \(error)")
        }
    }
    
    func test_fetchPopularMovies_withError_shouldSetErrorMessage() async {
        let viewModel = PopularMoviesViewModel(service: MockServiceError())
        
        await viewModel.fetchPopularMovies()

        XCTAssertEqual(viewModel.requestError, RequestError.invalidURL.errorDiscription)
    }
    
    func test_fetchPopularMovies_shouldAvoidDuplicateTitles() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)

        await viewModel.fetchPopularMovies()
        let countAfterFirstFetch = viewModel.movies?.count ?? 0

        await viewModel.fetchPopularMovies()

        let countAfterSecondFetch = viewModel.movies?.count ?? 0

        XCTAssertEqual(countAfterFirstFetch, countAfterSecondFetch)
    }
    
    func test_fetchPopularMovies_shouldSetIsLoadingCorrectly() async {
        let service = MockService()
        let viewModel = PopularMoviesViewModel(service: service)

        let expect = expectation(description: "Loading flag set properly")
        Task {
            await viewModel.fetchPopularMovies()
            XCTAssertFalse(viewModel.isLoading)
            expect.fulfill()
        }

        await fulfillment(of: [expect], timeout: 2)
    }

    func test_fetchPopularMovies_withEmptyData_shouldNotCrash() async {
        let service = MockEmptyData()
        let viewModel = PopularMoviesViewModel(service: service)

        await viewModel.fetchPopularMovies()

        XCTAssertTrue(viewModel.movies?.isEmpty ?? true)
        XCTAssertEqual(viewModel.requestError, RequestError.emptyResponse.errorDiscription)
    }

}
