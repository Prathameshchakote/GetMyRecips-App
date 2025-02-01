//
//  AsyncImageView.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var imageData: Data?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray
                    .opacity(0.3)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard imageData == nil else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let cachedData = try await ImageCache.shared.image(for: url) {
                imageData = cachedData
                return
            }
            
            let data = try await NetworkService.shared.fetchImage(from: url)
            await ImageCache.shared.cache(data: data, for: url)
            imageData = data
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

#Preview {
    AsyncImageView(url: Recipe.sampleImageUrl)
}
