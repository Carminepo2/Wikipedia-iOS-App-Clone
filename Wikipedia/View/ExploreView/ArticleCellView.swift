//
//  ArticleCellView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 10/12/21.
//

import SwiftUI

struct ArticleCellView: View {    
    let article: WikipediaFeedDataPage?
    let index: Int?
    let isLoading: Bool
    
    init(article: WikipediaFeedDataPage? = nil, index: Int? = nil, isLoading: Bool = false) {
        self.article = article
        self.index = index
        self.isLoading = isLoading
    }
    
    
    var body: some View {
        NavigationLink {
            if let article = article {
                WikipediaPageView(url: article.urls.mobile.page)
            }
        } label: {
            HStack {
                if let index = index {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 0.8)
                            .frame(width: 20, height: 20)
                        Text("\(index + 1)")
                            .font(Font.footnote)
                            .fontWeight(.light)
                    }
                    .foregroundColor(.blue)
                    .padding(.trailing, 8)
                    .unredacted()
                }
                

                VStack(alignment: .leading, spacing: 3) {
                    Text(isLoading ? "placeholder text" : (article?.title ?? "Unknown"))
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .lineLimit(1)
                    
                    Text(isLoading ? "placeholder description text" : (article?.description ?? ""))
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                }
                .padding(.vertical, 4)
                
                Spacer()

                if let thumbnail = article?.thumbnail?.source {

                    AsyncImage(
                        url: URL(string: thumbnail)!,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 43, height: 43)
                                .cornerRadius(5)
                        },
                        placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 43, height: 43)
                                .opacity(0.18)
                        }
                    )
                }
                
            }
        }
        //.padding(.horizontal)
        .redacted(reason: isLoading ? .placeholder : [])
    }
}


struct ArticleCellView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleCellView()
    }
}
