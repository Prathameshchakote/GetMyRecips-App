//
//  ImageCache.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import Foundation

actor ImageCache {
    static let shared = ImageCache()
    private var cache: [String: Data] = [:]
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func image(for url: String) async throws -> Data? {
        if let cachedData = cache[url] {
            return cachedData
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(url.hash.description)
        if let data = try? Data(contentsOf: fileURL) {
            cache[url] = data
            return data
        }
        
        return nil
    }
    
    func cache(data: Data, for url: String) async {
        cache[url] = data
        let fileURL = cacheDirectory.appendingPathComponent(url.hash.description)
        try? data.write(to: fileURL)
    }
}

