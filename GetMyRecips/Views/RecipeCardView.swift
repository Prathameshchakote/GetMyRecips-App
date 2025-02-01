//
//  RecipeCardView.swift
//  GetMyRecips
//
//  Created by Prathamesh on 2/2/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        GroupBox {
            if let photoUrl = recipe.photoUrlSmall {
                AsyncImageView(url: photoUrl)
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(recipe.name)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 1)
                
                HStack {
                    if let youtubeUrl = recipe.youtubeUrl, let videoId = recipe.youtubeVideoId {
                        HStack {
                            Image(systemName: "play.rectangle.fill")
                                .foregroundColor(.red)
                            Text("Watch Video")
                                .foregroundColor(.blue)
                                .underline()
                            Spacer()
                        }
                        .onTapGesture {
                            if let url = URL(string: youtubeUrl) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .padding(.bottom, 1)
                    }
                    
                    if let sourceUrl = recipe.sourceUrl {
                        HStack {
                            Image(systemName: "globe")
                            Text("Source")
                                .foregroundColor(.blue)
                                .underline()
                            Spacer()
                        }
                        .onTapGesture {
                            if let url = URL(string: sourceUrl) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}


struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardView(recipe: Recipe(
            uuid: UUID().uuidString,
            name: "Pasta Carbonara",
            cuisine: "Italian",
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: "https://example.com",
            youtubeUrl: "https://youtube.com/watch?v=exampleId"
        ))
        .padding()
    }
}

#Preview {
    RecipeCardView(recipe: Recipe.sampleRecipe)
}


