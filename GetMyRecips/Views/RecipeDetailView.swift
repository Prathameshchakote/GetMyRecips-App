//
//  RecipeDetailView.swift
//  GetMyRecips
//
//  Created by Prathamesh on 1/31/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let photoUrl = recipe.photoUrlLarge ?? recipe.photoUrlSmall {
                    AsyncImageView(url: photoUrl)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.secondary)
                        Text(recipe.cuisine)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                if let videoId = recipe.youtubeVideoId {
                    YouTubePreviewView(videoId: videoId)
                }
                
                if let sourceUrl = recipe.sourceUrl {
                    Link(destination: URL(string: sourceUrl)!) {
                        Label("View Original Recipe", systemImage: "safari")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe.sampleRecipe)
}
