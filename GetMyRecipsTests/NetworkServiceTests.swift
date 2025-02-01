//
//  NetworkServiceTests.swift
//  GetMyRecipsTests
//
//  Created by Prathamesh on 1/31/25.
//

import XCTest
@testable import GetMyRecips

class NetworkServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    fileprivate var session: URLSession!
    fileprivate var url: URL!
    fileprivate var sut: NetworkService!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        url = URL(string: "https://reques.in")
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLSessionProtocol.self]
        
        session = URLSession(configuration: config)
        sut = NetworkService(session: session)
    }
    
    override func tearDown() {
        url = nil
        session = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - NetworkService Tests
    
    func testsuccesscase() async {
        let recipes = [
            Recipe(uuid: "1", name: "Pasta", cuisine: "Italian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
            Recipe(uuid: "2", name: "Sushi", cuisine: "Japanese", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)
        ]
        
        let response = RecipeResponse(recipes: recipes)
        let jsonData = try? JSONEncoder().encode(response)
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!,jsonData)
        }
        
        do {
            let netser =  NetworkService(session: self.session)
            let dataa = try await netser.fetchRecipes("https://reques.in")
            
            XCTAssertEqual(dataa, recipes)
            XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty")
            XCTAssertEqual(recipes.count, 2)
            
            let firstRecipe = dataa[0]
            XCTAssertFalse(firstRecipe.uuid.isEmpty, "Recipe UUID should not be empty")
            XCTAssertFalse(firstRecipe.name.isEmpty, "Recipe name should not be empty")
            XCTAssertFalse(firstRecipe.cuisine.isEmpty, "Recipe cuisine should not be empty")
            
        } catch {
            XCTFail("Fetching recipes failed with error: \(error)")
        }
    }
    
    func testFetchRecipes_WithInvalidURL_ThrowsError() async {
        // Given
        let invalidURL = ""
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes(invalidURL)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }
    
    func testFetchRecipes_WithServerError_ThrowsError() async {
        // Given
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (response!,Data())
        }
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes("https://reques.in")
            XCTFail("Expected error to be thrown")
        } catch NetworkError.serverError(let code) {
            XCTAssertEqual(code, 500)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testFetchRecipes_WithInvalidJSON_ThrowsError() async {
        // Given
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!,"Invalid JSON".data(using: .utf8)!)
        }
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes("https://reques.in")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    // MARK: - fetchImage Tests
    
    func testFetchImage_WithValidResponse_ReturnsImageData() async throws {
        
        // Given
        let imgUrl: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let expectedData = "image data".data(using: .utf8)!
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: imgUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!,expectedData)
        }
        
        // When
        let result = try await sut.fetchImage(from: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        
        // Then
        XCTAssertEqual(result, expectedData)
    }
    
    func testFetchImage_WithInvalidURL_ThrowsError() async {
        // Given
        let invalidURL = ""
        
        // When/Then
        do {
            _ = try await sut.fetchImage(from: invalidURL)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }
    
    func testFetchImage_ServerError() async {
        // Given
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (response!,Data())
        }
        
        // When / Then
        do {
            _ = try await sut.fetchImage(from: "https://reques.in")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
}

