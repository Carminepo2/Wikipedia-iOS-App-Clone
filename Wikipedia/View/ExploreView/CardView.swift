//
//  CardView.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 09/12/21.
//

import SwiftUI

struct CardView<Content: View>: View {
    @EnvironmentObject var viewModel: WikipediaViewModel
    @State private var showActionSheet = false
    
    let content: Content
    let title: String
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(90))
                }
            }
            
            Text("On English Wikipedia")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                
                    content
                        
                
                
                
            }
            .padding(.top, 5)
            .shadow(color: shadowColor, radius: 10, x: 0, y: 0)
            
        }
        .padding()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(""),
                        buttons: [
                            .default(
                                Text("Hide this card"),
                                action: { print("TODO") }
                            ),
                            .default(
                                Text("Hide all \"\(title)\" cards"),
                                action: { print("TODO") }
                                
                            ),
                            .default(
                                Text("Customize Explore feed"),
                                action: { print("TODO") }
                            ),
                            .cancel(),
                        ]
            )
        }
        
    }
    
    private let shadowColor = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1)
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
