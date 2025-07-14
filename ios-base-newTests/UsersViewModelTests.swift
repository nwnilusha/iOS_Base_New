//
//  UsersViewModelTests.swift
//  ios-base-newTests
//
//  Created by Nilusha Niwanthaka Wimalasena on 14/7/25.
//

import Foundation

import XCTest
@testable import ios_base_new

final class UsersViewModelTests: XCTestCase {

    func test_loadData_successfullyLoadsUsers() async {
        let viewModel = UsersViewModel(service: MockService())

        await viewModel.loadData()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 10)
        XCTAssertEqual(viewModel.users.first?.name, "Leanne Graham")
        viewModel.clearCache()
    }

    func test_loadData_usesCachedUsersIfAvailable() async {
        let viewModel1 = UsersViewModel(service: MockService())
        await viewModel1.loadData()
        XCTAssertEqual(viewModel1.users.count, 10)

        let viewModel2 = UsersViewModel(service: MockServiceError())
        await viewModel2.loadData()

        XCTAssertEqual(viewModel2.users.count, 10)
        XCTAssertNil(viewModel2.errorMessage)
        viewModel1.clearCache()
    }

    func test_loadData_whenServiceThrows_setsErrorMessage() async {
        let viewModel = UsersViewModel(service: MockServiceError())

        await viewModel.loadData()

        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, RequestError.curruptData.errorDiscription)
        viewModel.clearCache()
    }

    func test_loadData_whenServiceReturnsEmptyArray_usersShouldBeEmpty() async {
        let viewModel = UsersViewModel(service: MockEmptyData())

        await viewModel.loadData()

        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        viewModel.clearCache()
    }

    func test_clearCache_shouldRemoveAllCachedUsers() async {
        let viewModel = UsersViewModel(service: MockService())
        await viewModel.loadData()

        XCTAssertEqual(viewModel.users.count, 10)

        viewModel.clearCache()
        
        let viewModelAfterClear = UsersViewModel(service: MockServiceError())
        await viewModelAfterClear.loadData()

        XCTAssertTrue(viewModelAfterClear.users.isEmpty)
        XCTAssertEqual(viewModelAfterClear.errorMessage, RequestError.curruptData.errorDiscription)
    }
}

