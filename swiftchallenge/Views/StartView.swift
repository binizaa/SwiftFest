//
//  StartView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct StartView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                
                Text("Bienvenido")
                    .font(.custom("Poppins-Bold", size: 45))
                    .foregroundColor(.red)
                    .frame(width: 260, alignment: .center)
            
                NavigationLink(destination: OnboardingView()) {
                    HStack {
                        Image(systemName: "arrow.forward")
                        Text("Iniciar")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 260, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                Image(.gotaPrincipal)
                    .resizable()
                    .frame(width: 400, height: 400)
                    .padding()
            }
            .offset(y: -35)
            .padding()
            .ignoresSafeArea()
           
            
        }
        .navigationBarBackButtonHidden()
       
    }
}

#Preview {
    StartView()
}
