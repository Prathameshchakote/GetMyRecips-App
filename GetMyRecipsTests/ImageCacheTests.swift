//
//  ImageCacheTests.swift
//  GetMyRecipsTests
//
//  Created by Prathamesh on 1/31/25.
//

import XCTest
@testable import GetMyRecips

class ImageCacheTests: XCTestCase {
    
    // MARK: - Properties
    
    var imageCache: ImageCache!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCache.shared
    }
    
    // MARK: - Test
    
    func testImageCaching() async throws {
        // Given
        let testUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        let testData = "test".data(using: .utf8)!
        
        // When
        await imageCache.cache(data: testData, for: testUrl)
        
        // Then
        let cachedData = try await imageCache.image(for: testUrl)
        XCTAssertNotNil(cachedData, "Cached data should not be nil")
        XCTAssertEqual(cachedData, testData, "Retrieved data should match cached data")
    }
}
