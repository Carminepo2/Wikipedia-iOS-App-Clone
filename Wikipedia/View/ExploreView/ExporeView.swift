//
//  ContentView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 06/12/21.
//

import SwiftUI

struct ExploreView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Today")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 40)
                    
                    
                    CardView(title: "Top read") {
                        TopFiveReadArticlesView()
                    }
                    BottomCardButton(label: "All top read articles") {
                        isPresented = true
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        AllTopReadArticlesView(isPresented: $isPresented)
                    }
                }
            }
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
        .searchable(text: $viewModel.searchTerm)
        .onReceive(viewModel.$searchTerm.debounce(for: 0.3, scheduler: RunLoop.main)) { seachTerm in
            Task {
                await viewModel.executeQuery()
            }
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
