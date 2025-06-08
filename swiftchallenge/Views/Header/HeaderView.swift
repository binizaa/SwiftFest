//
//  HeaderView.swift
//  swiftchallenge
//
//  Created by Leoni Bernabe on 07/06/25.
//

//import ri
import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack (alignment: .center) {
            Text("David")
                .font(.title2)
            Spacer()
            Text("Today")
                .font(.headline)
            Spacer()
                .frame(width: 10)
            
            Button(action: {
                // Acción del botón
                print("Botón presionado")
            }) {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
            
        }
    }
}

#Preview {
    HeaderView()
}
