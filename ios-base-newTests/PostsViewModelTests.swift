//
//  PostsViewModelTests.swift
//  ios-base-newTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 14/7/25.
//

import XCTest
@testable import ios_base_new

final class PostsViewModelTests: XCTestCase {
    
    func test_getPosts_successfullyLoadsPosts() async {
        let viewModel = PostsViewModel(service: MockService(), userId: 1)
        
        await viewModel.getPosts()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorDetails)
        XCTAssertEqual(viewModel.posts.count, 10)
        XCTAssertEqual(viewModel.posts.first?.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        viewModel.clearCache()
    }
    
    func test_getPosts_usesCachedPostsIfAvailable() async {
        let viewModel1 = PostsViewModel(service: MockService(), userId: 1)
        await viewModel1.getPosts()
        XCTAssertEqual(viewModel1.posts.count, 10)

        let viewModel2 = PostsViewModel(service: MockServiceError(), userId: 1)
        await viewModel2.getPosts()
        
        XCTAssertEqual(viewModel2.posts.count, 10)
        XCTAssertNil(viewModel2.errorDetails)
        viewModel1.clearCache()
    }
    
    func test_getPosts_handlesErrorCorrectly() async {
        let viewModel = PostsViewModel(service: MockServiceError(), userId: 99)
        
        await viewModel.getPosts()
        
        XCTAssertTrue(viewModel.posts.isEmpty)
        XCTAssertEqual(viewModel.errorDetails, RequestError.emptyResponse.localizedDescription)
        viewModel.clearCache()
    }
    
    func test_getPosts_whenEmptyResponse_postsShouldBeEmpty() async {
        let viewModel = PostsViewModel(service: MockEmptyData(), userId: 1)
        
        await viewModel.getPosts()
        
        XCTAssertTrue(viewModel.posts.isEmpty)
        XCTAssertNil(viewModel.errorDetails)
        viewModel.clearCache()
    }
    
    func test_clearCache_removesCachedPosts() async {
        let viewModel = PostsViewModel(service: MockService(), userId: 1)
        await viewModel.getPosts()
        XCTAssertEqual(viewModel.posts.count, 10)
        
        viewModel.clearCache()

        let viewModelAfterClear = PostsViewModel(service: MockServiceError(), userId: 1)
        await viewModelAfterClear.getPosts()
        
        XCTAssertTrue(viewModelAfterClear.posts.isEmpty)
        XCTAssertEqual(viewModelAfterClear.errorDetails, RequestError.emptyResponse.localizedDescription)
    }
}

