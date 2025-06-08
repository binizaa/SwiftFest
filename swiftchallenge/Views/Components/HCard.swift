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
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(selection.caption)
                    .font(.subheadline)
                    
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
//        .background(.ultraThinMaterial)
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
    OptionsToCapture(title: "Cámara", caption: "Toma una foto de tu comida", color: Color(hex: "6EA6F3"), image: Image(systemName: "camera")),
    OptionsToCapture(title: "Galería", caption: "Selecciona una foto de tu galería", color: Color(hex:"6EA6F3"), image: Image(systemName: "photo.on.rectangle")),
    OptionsToCapture(title: "Audio", caption: "Cuentanos por voz lo que has comido.", color: Color(hex:"6EA6F3"), image: Image(systemName: "mic"))
]

