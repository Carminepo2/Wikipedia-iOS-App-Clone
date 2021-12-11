//
//  AllTopReadArticlesView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 10/12/21.
//

import SwiftUI

struct AllTopReadArticlesView: View {
    
    @EnvironmentObject var viewModel: WikipediaViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section() {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Top read")
                                    .font(.title)
                                    .bold()
                                Spacer()
                                Button {
                                    isPresented = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                            
                            Text("On English Wikipedia")
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 40)
                    .listRowSeparator(.hidden)
                    
                    Section() {
                        ForEach(viewModel.topArticles, id: \.id) {
                            ArticleCellView(article: $0)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarHidden(true)

            }
            
        }
    }
}

//struct AllTopReadArticlesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllTopReadArticlesView()
//    }
//}
