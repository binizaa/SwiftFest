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
                
            }
        }
    }
}

#Preview {
    HomeView()
}

