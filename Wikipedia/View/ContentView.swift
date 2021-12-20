//
//  NavigationView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 10/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
    
    var body: some View {
        TabView {

            ExploreView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("Explore")
                }
            
            Text("Places")
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Places")
                }
            
            Text("Saved")
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
            
            Text("History")
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
            
            NavigationView {
                SearchView()
                    .navigationTitle("Search")
                    .searchable(text: $viewModel.searchTerm)
                    
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
           
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView()
//    }
//}
