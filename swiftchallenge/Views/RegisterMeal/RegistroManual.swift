import SwiftUI
import GoogleGenerativeAI

struct ManualFoodInputView: View {
    @State private var foodName: String = ""
    @State private var ingredients: [String] = []
    @State private var showResult = false

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
            Text("Ingresa el nombre del platillo")
                .font(.title2)
                .bold()

            TextField("Ej. Enchiladas verdes", text: $foodName)
                .padding()
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.words)
                .disableAutocorrection(true)

            Button("Buscar ingredientes") {
                fetchIngredients(for: foodName)
            }
            .disabled(foodName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)

            if showResult {
                if ingredients.isEmpty {
                    Text("No se encontraron ingredientes.")
                        .foregroundColor(.red)
                } else {
                    Text("Ingredientes:")
                        .font(.headline)

                    Text(ingredients.joined(separator: ", "))
                        .padding()
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer()
        }
        .padding()
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
                        self.showResult = true
                        saveIngredients(foodName: foodName, ingredients: array)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.ingredients = []
                        self.showResult = true
                    }
                }
            } catch {
                print("Error al obtener ingredientes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.ingredients = []
                    self.showResult = true
                }
            }
        }
    }

    func saveIngredients(foodName: String, ingredients: [String]) {
        let savedData = SavedIngredients(foodName: foodName, ingredients: ingredients)

        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("ingredients.json")

                var existingData = [SavedIngredients]()

                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    existingData = try JSONDecoder().decode([SavedIngredients].self, from: data)
                }

                existingData.removeAll { $0.foodName.lowercased() == foodName.lowercased() }
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
    ManualFoodInputView()
}

