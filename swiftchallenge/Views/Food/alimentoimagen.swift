import SwiftUI
import CoreML

struct alimentosView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var predictionLabel: String = ""
    @State private var ingredients: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            Button("Seleccionar Imagen") {
                isPickerPresented = true
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()

                Button("Predecir imagen") {
                    classifyImage(image)
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
            }

            if !predictionLabel.isEmpty {
                Text("Resultado: \(predictionLabel)")
                    .font(.headline)
                    .padding(.top)

                if !ingredients.isEmpty {
                    Text("Ingredientes: \(ingredients.joined(separator: ", "))")
                        .padding(.top, 5)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
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

            GeminiService.shared.obtenerIngredientes(para: result.classLabel) { ingredientes in
                self.ingredients = ingredientes
            }

        } catch {
            print("Error en la predicción: \(error.localizedDescription)")
        }
    }
}


#Preview {
    alimentosView()
}


