//
//  HomeView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct PageHomeView: View {
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 0) {
                HeaderView()
                    .padding(.horizontal)
                
                
                TabView {
                    XYChart()
                    PieChart()
                }
                .frame(width: 380, height: 450)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                LazyVStack{
                    Text("aqui va otra cosa :D")
                }
                
            }
        }
    }
}

#Preview {
    PageHomeView()
}

