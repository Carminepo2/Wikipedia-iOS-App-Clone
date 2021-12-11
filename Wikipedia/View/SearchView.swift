//
//  SearchView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 10/12/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: WikipediaViewModel
    
    var body: some View {
        ForEach(viewModel.result, id: \.id) { result in
            NavigationLink {
                WikipediaPageView(url: "http://TODO")
            } label: {
                Text(result.title)
            }
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
