//
//  ContentView.swift
//  swiftchallenge
//
//  Created by Kevin Garcia on 07/06/25.
// d

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    @State private var animateTransition = false

        var body: some View {
            ZStack {
                if hasSeenOnboarding {
                    HomeView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                } else {
                    StartView()
                        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
        }
}

#Preview {
    ContentView()
}
