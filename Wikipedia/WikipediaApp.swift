//
//  WikipediaApp.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 06/12/21.
//

import SwiftUI

@main
struct WikipediaApp: App {
    let wikipediaViewModel = WikipediaViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wikipediaViewModel)
        }
    }
}
