//
//  WikipediaPageView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 07/12/21.
//

import SwiftUI

struct WikipediaPageView: View {
    
    let url: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        WebView(url: URL(string: url)!)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.all)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    
                    Image("Wikipedia_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.vertical)
                        .onTapGesture {
                            dismiss()
                        }
                }
            })
    }
}

//struct WikipediaPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        WikipediaPageView(key: "Jupiter")
//    }
//}
