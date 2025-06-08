//
//  OnBoardingPage.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    imageName: "glucometro",
                    title: "Traqueo de Glucosa",
                    description: "Registra tus niveles de glucosa de forma sencilla y rápida.",
                    index: 0
                )
                .tag(0)
                
                OnboardingPage(
                    imageName: "graficas",
                    title: "Gráficas Inteligentes",
                    description: "Visualiza tu progreso con gráficas claras y comprensibles.",
                    index: 1
                )
                .tag(1)
                
                OnboardingPage(
                    imageName: "estrella",
                    title: "Establece Metas",
                    description: "Define objetivos personalizados y mejora tu salud día a día.",
                    index: 2
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == currentPage ? Color.red : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }

            HStack {
                if currentPage > 0 {
                    Button("Back") {
                        currentPage -= 1
                    }
                    .padding()
                    .foregroundColor(.gray)
                   
                } else {
                    Button("Skip") {
                    }
                    .padding()
                    .foregroundColor(.gray)
                
                }

                Spacer()
                Button {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        hasSeenOnboarding.toggle()
                        print(hasSeenOnboarding)
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden()
    }
}

struct OnboardingPage: View {
    var imageName: String
    var title: String
    var description: String
    var index: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()

            Text(title)
                .font(.title)
                .fontWeight(.bold)
            

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}


#Preview {
    OnboardingView()
}
