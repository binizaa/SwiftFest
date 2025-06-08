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

            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)

                Button {
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .offset(x: 8, y: 8)
            }

            VStack(spacing: 4) {
                Text("Biniza Ruiz")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("biniza@email.com")
                    .foregroundColor(.gray)
                    .font(.subheadline)
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
