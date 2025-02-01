//
//  NetworkService.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import Foundation

// MARK: - URLSession Protocol

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Protocol Conformance

extension URLSession: URLSessionProtocol { }

// MARK: - NetworkService

actor NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = (session as? URLSession) ?? URLSession(configuration: config)
    }
    
    func fetchRecipes(_ urlString: String) async throws -> [Recipe] {
        print(urlString)
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return recipeResponse.recipes
    }
    
    func fetchImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
