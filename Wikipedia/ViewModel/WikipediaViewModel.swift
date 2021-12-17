//
//  WikipediaViewModel.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 08/12/21.
//

import Foundation

class WikipediaViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    
    @Published private(set) var result: [WikipediaSearchResult] = []
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var isLoadingFeed: Bool = false
    @Published private var feedData: WikipediaFeedDataResponse?
    @Published var chosenSearchLanguage: WikipediaLanguage = .EN
    @Published private(set) var recentSearches: [RecentSearch] = []
    
    
    private var searchHandle: Task<Void, Never>?
    
    init() {
        getFeedData()
        refreshRecentSearches()
    }
    
    var isfeedDataSuccessfullyFetched: Bool {
        feedData != nil
    }
    
    var featuredArticle: WikipediaFeedDataPage? {
        if let feedData = feedData {
            return feedData.featuredArticle
        }
        return nil
    }
    
    var topArticles: [WikipediaFeedDataPage] {
        if let feedData = feedData {
            return feedData.topRead.articles
        }
        return []
    }
    
    var onThisDay: [WikipediaFeedDataOnThisDay] {
        if let feedData = feedData {
            return feedData.onThisDay
        }
        return []
    }
    
    func addRecentSearch(forUrl url: String) {
        CoreDataManager.shared.addRecentSearch(query: searchTerm, url: url)
        refreshRecentSearches()
    }
    
    func clearSearches() {
        CoreDataManager.shared.clearSearches()
        refreshRecentSearches()
    }
    
    func deleteRecentSearch(at offsets: IndexSet) {
        for index in offsets {
            let recentSearch = recentSearches[index]
            CoreDataManager.shared.deleteRecentSearch(recentSearch)
        }
        refreshRecentSearches()
    }
    
    private func refreshRecentSearches() {
        recentSearches = CoreDataManager.shared.loadRecentSearches()
    }
    
    func getFeedData() {
        Task {
            DispatchQueue.main.async {
                self.isLoadingFeed = true
            }
            
            let url = getFeedDataURL()
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)
                let decodedResponse = try JSONDecoder().decode(WikipediaFeedDataResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.feedData = decodedResponse
                    self.isLoadingFeed = false
                }
                
            } catch {
                print("error --->", error)
            }
        }
    }
    
    
    func executeQuery() async {
        searchHandle?.cancel()
        let currentSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
        if currentSearchTerm.isEmpty {
            result = []
            isSearching = false
        } else {
            searchHandle = Task {
                DispatchQueue.main.async {
                    self.isSearching = true
                }
                let queryResult = await searchWikipedia(for: searchTerm)
                
                DispatchQueue.main.async {
                    self.result = queryResult
                }
                if !Task.isCancelled {
                    DispatchQueue.main.async {
                        self.isSearching = false
                    }
                    
                }
            }
        }
    }
    
    
    private func searchWikipedia(for query: String, limit: Int = 20, thumbSize: Int = 50) async -> [WikipediaSearchResult] {
        
        let escapedSeachTerm = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let url = URL(string: "https://api.wikimedia.org/core/v1/wikipedia/\(chosenSearchLanguage.rawValue)/search/title?q=\(escapedSeachTerm)&limit=\(limit)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            if let decodedResponse = try? JSONDecoder().decode(WikipediaSearchResponse.self, from: data) {
                return decodedResponse.pages
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
        return []
    }
    
    
    private func getFeedDataURL() -> URL {
        let date = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let stringMonth = month <= 9 ? "0\(month)": String(month)
        let day = calendar.component(.day, from: date)
        let stringDay = day <= 9 ? "0\(day)": String(day)
        
        return URL(string: "https://api.wikimedia.org/feed/v1/wikipedia/en/featured/\(year)/\(stringMonth)/\(stringDay)")!
    }
    
    enum WikipediaLanguage: String {
        case EN = "en"
        case IT = "it"
    }
}
