//
//  HomeView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 0) {
                HeaderView()
                    .padding(.horizontal)
                
                
                
//                LazyVStack {
//                    ForEach(1 ..< 100) { _ in
//                        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                    }
//                }
            }
        }
    }
}

#Preview {
    HomeView()
}
