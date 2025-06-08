//
//  CaptureMealView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct CaptureMealView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                   
                    ForEach(optionsToCapture) { section in
                        NavigationLink(destination: DetailView()) { // Aqui conenten todo xd
                            HCard(selection: section)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
       
    }
}

#Preview {
    CaptureMealView()
}

