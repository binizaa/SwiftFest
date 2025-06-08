//
//  response.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 07/06/25.
//

import SwiftUI
import PhotosUI

struct Response: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

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
                    LogMealUploader.enviarImagen(imagen)
                }
            }
            .disabled(selectedImage == nil)
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}
