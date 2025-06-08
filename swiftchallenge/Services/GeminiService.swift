//
//  GeminiService.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 08/06/25.
//

// Services/GeminiService.swift

import Foundation
import GoogleGenerativeAI

struct SavedIngredients: Codable {
    var foodName: String
    var ingredients: [String]
}

class GeminiService {
    static let shared = GeminiService()
    private let model: GenerativeModel

    private init() {
        self.model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKey.default
        )
    }

    func obtenerIngredientes(para foodName: String, completion: @escaping ([String]) -> Void) {
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
                        completion(array)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            } catch {
                print("Error al obtener ingredientes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func completarGlycemyIndex(
        para alimentos: [AlimentoDetectado],
        completion: @escaping ([AlimentoDetectado]) -> Void
    ) {
        Task {
            var alimentosConIndice: [AlimentoDetectado] = []

            for alimento in alimentos {
                let prompt = "Dame el índice glucémico promedio del alimento \(alimento.nombre), solo el número. Si no se encuentra, responde un promedio de su familia."

                do {
                    let response = try await model.generateContent(prompt)

                    if let texto = response.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                       let valor = Double(texto.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                        
                        let actualizado = AlimentoDetectado(
                            nombre: alimento.nombre,
                            familia: alimento.familia,
                            glycemyIndex: valor
                        )
                        alimentosConIndice.append(actualizado)

                    } else {
                        print("⚠️ No se pudo convertir el índice para: \(alimento.nombre)")
                        alimentosConIndice.append(alimento)
                    }

                } catch {
                    print("❌ Error al consultar Gemini para \(alimento.nombre): \(error.localizedDescription)")
                    alimentosConIndice.append(alimento)
                }
            }

            DispatchQueue.main.async {
                completion(alimentosConIndice)
            }
        }
    }

}
