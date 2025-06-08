//
//  ProfileaView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 08/06/25.
//

import SwiftUI

struct DiabetesProfileView: View {
    var body: some View {
        VStack(spacing: 24) {

            ZStack(alignment: .top) {
                
                LinearGradient(
                                   colors: [Color.red.opacity(0.7), Color.red.opacity(0.2)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing
                )
                .frame(height: 200) 
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .offset(y: -30)

                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)


            }

            VStack(spacing: 4) {
                Text("Biniza Ruiz")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("biniza@email.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
            }

            HStack(spacing: 20) {
                HealthStatView(title: "Promedio", value: "110", unit: "mg/dL")
                Divider().frame(height: 40)
                HealthStatView(title: "Última", value: "126", unit: "mg/dL")
                Divider().frame(height: 40)
                HealthStatView(title: "Objetivo", value: "100", unit: "mg/dL")
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text("Datos:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                InfoView(icon: "person", title: "Género", value: "Mujer")
                InfoView(icon: "drop.fill", title: "Diabetes", value: "Tipo 2")
                InfoView(icon: "pill.circle", title: "Medicamentos", value: "Metformina, Insulina")
              
            }

        }
        .padding()
    }
}


#Preview {
    DiabetesProfileView()
}
