//
//  PlateSelectionView.swift
//  swiftchallenge
//
//  Created by Leoni Bernabe on 08/06/25.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct PlateSelectionView: View {
    let name: String
    let family: String
    let color: Color
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                // Etiqueta lateral izquierda
                Rectangle()
                    .fill(color)
                    .frame(width: 90, height: 80)
                    .cornerRadius(50)
                    .offset(x: -10)

                // Tarjeta principal
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name: \(name)")
                        Text("Family: \(family)")
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.gray.opacity(0.15))
                        )
                )
            }
        }
        .padding()
    }
}


#Preview {
    PlateSelectionView(name: "", family: "", color: Color.red)
}
