//
//  WikipediaAPIData.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 08/12/21.
//

import Foundation

struct WikipediaSearchResponse: Codable {
  let pages: [WikipediaSearchResult]
}

struct WikipediaSearchResult: Codable {
    let id: Int
    let key: String
    let title: String
    let description: String?
    let thumbnail: WikipediaSearchResultThumbnail?
}

struct WikipediaSearchResultThumbnail: Codable {
    let url: String?
}

struct WikipediaPageResponse: Codable {
    let parse: WikipediaArticle
}

struct WikipediaArticle: Codable {
    let title: String
    let text: WikipediaHTML
}

struct WikipediaHTML: Codable {
    let html: String
    
    enum CodingKeys: String, CodingKey {
        case html = "*"
    }
}


struct WikipediaTopArticlesResponse: Decodable {
    let items: Array<WikipediaTopArticles>
}

struct WikipediaTopArticles: Decodable {
    let articles: Array<WikipediaTopArticle>
}

struct WikipediaTopArticle: Decodable {
    let article: String
    let views: Int
    let rank: Int
}


struct WikipediaFeedDataResponse: Codable {
    let featuredArticle: WikipediaFeedDataPage
    let topRead: WikipediaFeedDataTopRead
    let onThisDay: Array<WikipediaFeedDataOnThisDay>
    
    enum CodingKeys: String, CodingKey {
        case featuredArticle = "tfa"
        case topRead = "mostread"
        case onThisDay = "onthisday"
    }
}

struct WikipediaFeedDataOnThisDay: Codable {
    let text: String
    let pages: Array<WikipediaFeedDataPage>
    let year: Int
}

struct WikipediaFeedDataTopRead: Codable {
    let articles: Array<WikipediaFeedDataPage>
}

struct WikipediaFeedDataPage: Codable {
    let id: Int
    let key: String
    let title: String
    let thumbnail: WikipediaFeedDataThumbnail?
    let description: String?
    let urls: WikipediaFeedDataURLS
    let extract: String
    let titles: WikipediaFeedDataTitles
    
    enum CodingKeys: String, CodingKey {
        case id = "pageid"
        case key = "title"
        case title = "displaytitle"
        case thumbnail = "thumbnail"
        case description = "description"
        case urls = "content_urls"
        case extract = "extract"
        case titles = "titles"
    }
}

struct WikipediaFeedDataTitles: Codable {
    let normalized: String
}

struct WikipediaFeedDataThumbnail: Codable {
    let source: String
}

struct WikipediaFeedDataURLS: Codable {
    let mobile: WikipediaFeedDataMobileURLS
}

struct WikipediaFeedDataMobileURLS: Codable {
    let page: String
}


