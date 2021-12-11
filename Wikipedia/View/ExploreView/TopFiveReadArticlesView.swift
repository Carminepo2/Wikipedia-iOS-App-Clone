//
//  MostViewedArticlesView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 08/12/21.
//

import SwiftUI

struct TopFiveReadArticlesView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
    let maxMostViewedArticles =  5
    
    
    var body: some View {
            VStack(alignment: .leading) {
                ForEach(0..<5) {
                    ArticleCellView(article: viewModel.topArticles.elementAtIndex($0), index: $0, isLoading: viewModel.isLoadingFeed)
                }
            }
            .padding(.vertical, 20)
        
        
    }
    
}

struct MostViewedArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        TopFiveReadArticlesView()
    }
}

