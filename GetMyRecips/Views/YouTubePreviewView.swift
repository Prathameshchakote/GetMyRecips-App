//
//  YouTubePreviewView.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import SwiftUI

struct YouTubePreviewView: View {
    let videoId: String
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: openYouTubeVideo) {
                VStack(spacing: 8) {
                    AsyncImageView(url: "https://img.youtube.com/vi/\(videoId)/maxresdefault.jpg")
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .shadow(radius: 8)
                        )
                    
                    Label("Watch on YouTube", systemImage: "play.tv.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            .buttonStyle(PlainButtonStyle()) // This prevents the default button highlighting
        }
        .padding()
    }
    
    private func openYouTubeVideo() {
        
        // Try to open YouTube app first
        let youtubeAppUrl = URL(string: "youtube://\(videoId)")!
        if UIApplication.shared.canOpenURL(youtubeAppUrl) {
            openURL(youtubeAppUrl)
        } else {
            
            // Fallback to website
            let youtubeWebUrl = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
            openURL(youtubeWebUrl)
        }
    }
}

#Preview {
    YouTubePreviewView(videoId: Recipe.samplevideoId)
}
