//
//  CaptureMealView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct CaptureMealView: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ForEach(optionsToCapture) { section in
                    HCard(selection: section)
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    CaptureMealView()
}

