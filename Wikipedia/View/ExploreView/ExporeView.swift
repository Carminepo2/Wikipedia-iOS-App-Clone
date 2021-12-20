//
//  ContentView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 06/12/21.
//

import SwiftUI

struct ExploreView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
        
    var body: some View {
        NavigationView {
            if !viewModel.isLoadingFeed && !viewModel.isfeedDataSuccessfullyFetched {
                Text("Network Error")
                Button("Try again") {
                    viewModel.getFeedData()
                }
            } else if viewModel.isLoadingFeed {
                ProgressView()
            } else {
                ExploreCards()
                    .searchable(text: $viewModel.searchTerm)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Image("Wikipedia_wordmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .padding(.vertical)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                print("Settings")
                            } label: {
                                Image(systemName: "gear")
                            }
                            
                        }
                    })
            }
        }
    }
    
    
   
}

struct ExploreCards: View {
    @EnvironmentObject var viewModel: WikipediaViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    
    @State private var areAllTopArticlesPresented = false

    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Today")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 40)
                        
                        CardView(title: "Featured article", content: FeaturedArticleView.init)
                        CardView(title: "Top read", content: TopFiveReadArticlesView.init)
                        
                        BottomCardButton(label: "All top read articles", action: showAllTopArticles)
                        .fullScreenCover(isPresented: $areAllTopArticlesPresented) {
                            AllTopReadArticlesView(isPresented: $areAllTopArticlesPresented)
                        }
                    }
                }
                .opacity(isSearching ? 0 : 1)
                
                if isSearching {
                    SearchView()
                }
            }
        }
        
        
    }
    
    func showAllTopArticles() {
        areAllTopArticlesPresented = true
    }
}

struct Test: View {
    @EnvironmentObject var viewModel: WikipediaViewModel

    @Environment(\.isSearching) var isSearching

    var body: some View {
        VStack {
            Text(viewModel.searchTerm)
            Text("\(isSearching ? "Cercando" : "Non Cercando")")

        }
    }
}

struct BottomCardButton: View {
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                action()
            } label: {
                HStack {
                    Text(label)
                        .bold()
                        .font(.subheadline)
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.blue)
            }
        }
        .offset(y: -10)
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
