//
//  HCard.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct HCard: View {
    var selection = optionsToCapture[0]
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(selection.title)
                    .font(.custom("Poppins-Bold", size: 28))
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(selection.caption)
                    
            }
            Divider()
            selection.image
                .resizable()
                .frame(width: 60, height: 50)
                
            //image
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .foregroundColor(.white)
        .background(selection.color)
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
    
    
}

struct HCard_Previews: PreviewProvider {
    static var previews: some View {
        HCard()
    }
}


struct OptionsToCapture: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var color: Color
    var image: Image
}

var optionsToCapture = [
    OptionsToCapture(title: "Cámara", caption: "Toma una foto de tu comida", color: Color(hex: "9CC5FF"), image: Image(systemName: "camera")),
    OptionsToCapture(title: "Galería", caption: "Selecciona una foto de tu galería", color: Color(hex:"6E6AE8"), image: Image(systemName: "photo.on.rectangle")),
    OptionsToCapture(title: "Audio", caption: "Cuentanos por voz lo que has comido.", color: Color(hex:"005FE7"), image: Image(systemName: "mic"))
]


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
