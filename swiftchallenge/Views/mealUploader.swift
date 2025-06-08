//
//  mealUploader.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 08/06/25.
//

import SwiftUI
import PhotosUI

struct mealUploader: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var cargando = false
    @State private var alimentosDetectados: [AlimentoDetectado] = []

    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            PhotosPicker("Selecciona una imagen", selection: $selectedItem, matching: .images)

            Button("Enviar a LogMeal") {
                if let imagen = selectedImage {
                    cargando = true
                    alimentosDetectados = []  // Limpia resultados anteriores

                    LogMealUploader.enviarImagen(imagen) { alimentos in
                        DispatchQueue.main.async {
                            alimentosDetectados = alimentos
                            cargando = false
                        }
                    }
                }
            }
            .disabled(selectedImage == nil || cargando)

            if cargando {
                ProgressView("Analizando imagen...")
                    .padding()
            }

            if !alimentosDetectados.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alimentos detectados:")
                        .font(.headline)
                    ForEach(alimentosDetectados, id: \.self) { alimento in
                        Text("- \(alimento.nombre) (\(alimento.familia)) - \(alimento.glycemyIndex)")
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    alimentosDetectados = []
                }
            }
        }
    }
}

#Preview {
    mealUploader()
}
