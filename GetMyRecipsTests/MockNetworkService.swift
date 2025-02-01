//
//  MockNetworkService.swift
//  GetMyRecipsTests
//
//  Created by Prathamesh on 2/3/25.
//

import Foundation
@testable import GetMyRecips

// MARK: - Mock NetworkService

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockRecipes: [Recipe] = []
    
    func fetchRecipes(_ urlString: String) async throws -> [Recipe] {
        if shouldSucceed {
            return mockRecipes
        } else {
            throw NetworkError.serverError(500)
        }
    }
    
    func fetchImage(from urlString: String) async throws -> Data {
        // Implement if needed for tests
        return Data()
    }
}
