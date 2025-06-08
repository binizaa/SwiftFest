//
//  ContentView.swift
//  swiftchallenge
//
//  Created by Kevin Garcia on 07/06/25.
// d

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var predictionLabel: String = ""

    var body: some View {
        VStack {
            Button("Seleccionar Imagen") {
                isPickerPresented = true
            }

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()

                Button("Predecir imagen") {
                    classifyImage(image)
                }
            }

            if !predictionLabel.isEmpty {
                Text("Resultado: \(predictionLabel)")
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }

    func classifyImage(_ image: UIImage) {
        guard let buffer = image.toCVPixelBuffer(width: 299, height: 299) else {
            print("No se pudo convertir la imagen")
            return
        }

        do {
            let model = try food(configuration: MLModelConfiguration())
            let result = try model.prediction(image: buffer)
            predictionLabel = result.classLabel
        } catch {
            print("Error en la predicción: \(error.localizedDescription)")
        }
    }
}


#Preview {
    ContentView()
}
