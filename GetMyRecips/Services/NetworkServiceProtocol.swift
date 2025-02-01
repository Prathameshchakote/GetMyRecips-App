//
//  NetworkServiceProtocol.swift
//  GetMyRecips
//
//  Created by Prathamesh on 2/3/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchRecipes(_ urlString: String) async throws -> [Recipe]
    func fetchImage(from urlString: String) async throws -> Data
}
