//
//  SearchView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 10/12/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: WikipediaViewModel
    @State private var confirmationClearRecentSearchesShown = false
    
    var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 20) {
                    LanguageButton(language: .EN, title: "English")
                    LanguageButton(language: .IT, title: "Italiano")
                    Spacer()
                    Button {
                        print("More")
                    } label: {
                        Text("More")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .padding(.top, 4)
            
                
                if viewModel.searchTerm.isEmpty {
                    
                    List {
                        Section {
                            HStack {
                                Text("Recently searched")
                                    .bold()
                                Spacer()
                                Text("Clear")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        confirmationClearRecentSearchesShown = true
                                    }
                            }
                            .padding(.vertical)
                            .alert(isPresented:$confirmationClearRecentSearchesShown) {
                                Alert(
                                    title: Text("Delete all recent searches?"),
                                    message: Text("This action cannot be undone!"),
                                    primaryButton: .destructive(Text("Delete All")) {
                                        viewModel.clearSearches()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                        ForEach(viewModel.recentSearches, id: \.objectID) { recentSearch in
                            NavigationLink {
                                if let url = recentSearch.url {
                                    WikipediaPageView(url: url)
                                }
                            } label: {
                                Text(recentSearch.query ?? "Unknown")
                            }
                        }
                        .onDelete(perform: viewModel.deleteRecentSearch)
                    }
                    .listStyle(.plain)
                } else {
                    
                    if viewModel.isSearching {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else if !viewModel.isSearching && viewModel.result.isEmpty {
                        VStack {
                            Spacer()
                            Text("No results")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    
                    
                    else {
                        List {
                            ForEach(viewModel.result, id: \.id) { result in
                                SearchResultCellView(result: result)
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                }
                
            }
            .disableAutocorrection(true)
            .onReceive(viewModel.$searchTerm.debounce(for: 0.3, scheduler: RunLoop.main)) { seachTerm in
                Task {
                    await viewModel.executeQuery()
                }
            }
            .onReceive(viewModel.$chosenSearchLanguage) { _ in
                Task {
                    await viewModel.executeQuery()
                }
            }
        }
    
}

struct SearchResultCellView: View {
    let result: WikipediaSearchResult
    @EnvironmentObject var viewModel: WikipediaViewModel

    
    var body: some View {
        
        let url = "https://\(viewModel.chosenSearchLanguage.rawValue).wikipedia.org/wiki/\(result.key)"
        
        NavigationLink {
            WikipediaPageView(url: url)
                .onAppear {
                    viewModel.addRecentSearch(forUrl: url)
                }
        } label: {
            HStack {
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(result.title)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .lineLimit(1)
                    
                    
                    if let description = result.description {
                        Text(description)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
                .padding(.vertical, 4)
                
                Spacer()
                
                AsyncImage(
                    url: URL(string: "https:" + (result.thumbnail?.url ?? "//"))!,
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(WikipediaViewModel())
    }
}


struct LanguageButton: View {
    @EnvironmentObject var viewModel: WikipediaViewModel
    
    let language: WikipediaViewModel.WikipediaLanguage
    let title: String
    
    
    var body: some View {
        
        let isActive = viewModel.chosenSearchLanguage == language
        
        Button {
            viewModel.chosenSearchLanguage = language
            
        } label: {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(isActive ? .blue : .secondary)
                    .frame(width: 25, height: 25)
                    .overlay {
                        Text(language.rawValue.uppercased())
                            .fontWeight(.heavy)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                Text(title)
                    .fontWeight(.light)
                    .font(.subheadline)
                    .offset(x: -2)
                    .foregroundColor(isActive ? .blue : .secondary)
            }
            .padding(.horizontal, 6)
            .overlay {
                if isActive {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.blue)
                        .offset(y: 20)
                }
            }
            
        }
        
    }
}

