//
//  FeaturedArticleView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 11/12/21.
//

import SwiftUI

struct FeaturedArticleView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
    @State var isSaved: Bool = false
    
    var article: WikipediaFeedDataPage? {
        viewModel.featuredArticle
    }
    
    var body: some View {
        NavigationLink {
            if let article = article {
                WikipediaPageView(url: article.urls.mobile.page)
            }
        } label: {
            VStack(alignment: .leading) {
                if let thumbnail = article?.thumbnail?.source {
                    AsyncImage(
                        url: URL(string: thumbnail)!,
                        content: { image in
                            image.resizable()
                                .cornerRadius(5, corners: [.topLeft, .topRight])
                                .frame(maxHeight: 200)
                                //.scaledToFill()
                            
                            
                        },
                        placeholder: {
                            Rectangle()
                                .fill(.secondary)
                                .frame(height: 200)
                                .cornerRadius(5, corners: [.topLeft, .topRight])
                                .opacity(0.18)
                        }
                    )
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(article?.titles.normalized ?? "")
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.thin)
                        .lineLimit(1)
                    
                    Text(article?.description ?? "")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Text(article?.extract ?? "")
                        .lineLimit(4)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    
                    
                    HStack {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        Text(isSaved ? "Saved for later" : "Save for later")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isSaved.toggle()
                        Haptics.shared.play(.medium)
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
        }
        
        
    }
}

//struct FeaturedArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeaturedArticleView()
//    }
//}
