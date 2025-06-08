import SwiftUI
import CoreML
import GoogleGenerativeAI

struct alimentosView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var predictionLabel: String = ""
    @State private var ingredients: [String] = []
    
    let model = GenerativeModel(
        name: "gemini-1.5-flash",
        apiKey: APIKey.default
    )
    
    struct SavedIngredients: Codable {
        var foodName: String
        var ingredients: [String]
    }

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
            fetchIngredients(for: result.classLabel)

        } catch {
            print("Error en la predicción: \(error.localizedDescription)")
        }
    }

    func fetchIngredients(for foodName: String) {
        Task {
            do {
                let prompt = "Dime los ingredientes más comunes en un plato de \(foodName), separados por comas."
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    let array = cleanedText
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    DispatchQueue.main.async {
                        self.ingredients = array
                        saveIngredients(foodName: foodName, ingredients: array)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.ingredients = []
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.ingredients = []
                }
                print("Error al obtener ingredientes: \(error.localizedDescription)")
            }
        }
    }
    
    func saveIngredients(foodName: String, ingredients: [String]) {
        let savedData = SavedIngredients(foodName: foodName, ingredients: ingredients)
        
        do {
            _ = try JSONEncoder().encode(savedData)
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("ingredients.json")
                
                var existingData = [SavedIngredients]()
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    existingData = try JSONDecoder().decode([SavedIngredients].self, from: data)
                }
                
                existingData.removeAll { $0.foodName == foodName }
                existingData.append(savedData)
                
                let updatedJsonData = try JSONEncoder().encode(existingData)
                try updatedJsonData.write(to: fileURL, options: .atomic)
                
                print("Ingredientes guardados en: \(fileURL)")
            }
        } catch {
            print("Error guardando ingredientes: \(error.localizedDescription)")
        }
    }
}


#Preview {
    ContentView()
}


