//
//  RegistroPorVozView.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 08/06/25.
//

import SwiftUI

struct RegistroPorVozView: View {
    @StateObject var reconocedor = SpeechRecognizer()
    @State private var alimentoDetectado = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Habla ahora...")
                .font(.headline)

            Text(reconocedor.transcripcion)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            Button(reconocedor.estaEscuchando ? "Detener" : "Iniciar") {
                if reconocedor.estaEscuchando {
                    reconocedor.detenerEscucha()
                    alimentoDetectado = reconocedor.transcripcion
                    // Aquí puedes llamar a LogMealUploader o GeminiService
                } else {
                    reconocedor.solicitarPermisos { autorizado in
                        if autorizado {
                            reconocedor.comenzarEscucha()
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    RegistroPorVozView()
}
