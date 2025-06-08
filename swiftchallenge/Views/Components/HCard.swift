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
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(selection.caption)
                    .font(.subheadline)
                
                    
            }
            Divider()
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 70, height: 70)
                selection.image
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.white)
                        }

                
            //image
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .foregroundColor(.white)
        .background(Color("Blue"))
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
    OptionsToCapture(title: "Cámara", caption: "Toma una foto de tu comida", color: Color("Blue"), image: Image(systemName: "camera")),
<<<<<<< HEAD
    OptionsToCapture(title: "Galería", caption: "Selecciona una foto de tu galería", color: Color(.gray), image: Image(systemName: "photo.on.rectangle")),
    OptionsToCapture(title: "Audio", caption: "Cuentanos por voz lo que has comido.", color: Color("Blue"), image: Image(systemName: "mic")),
    OptionsToCapture(title: "Text", caption: "Escribenos lo que has comido.", color: Color(.gray), image: Image(systemName: "textformat"))
=======
    OptionsToCapture(title: "Galería", caption: "Selecciona una foto de tu galería", color: Color("Blue"), image: Image(systemName: "photo.on.rectangle")),
    OptionsToCapture(title: "Manual", caption: "Escribe lo que comiste.", color: Color(.gray), image: Image(systemName: "pencil"))
>>>>>>> 7c57617 (fix and style)
]

