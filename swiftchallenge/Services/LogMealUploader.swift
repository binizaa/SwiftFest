//
//  LogMealUploader.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 07/06/25.
//

import Foundation
import UIKit

class LogMealUploader {
    private static let endpoint = "https://api.logmeal.com/v2/image/segmentation/complete/v1.0?language=spa"
    private static let token = "544427ee3d2e42091721ec5da25ec6290297dad8"

    static func enviarImagen(_ imagen: UIImage, completion: @escaping ([AlimentoDetectado]) -> Void) {
        guard let url = URL(string: endpoint) else {
            print("❌ URL inválida")
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let resizedImage = imagen.reescalar(nuevoAncho: 600)
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
            print("❌ No se pudo convertir la imagen a JPEG")
            completion([])
            return
        }

        request.httpBody = construirBody(imagenData: imageData, boundary: boundary)

        print("📤 Enviando solicitud a: \(url)")
        print("🧾 Headers: \(request.allHTTPHeaderFields ?? [:])")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error de red: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ No se recibió una respuesta HTTP válida")
                completion([])
                return
            }

            print("✅ Código de estado HTTP: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("❗ Respuesta inesperada del servidor")
            }

            guard let data = data else {
                print("❌ No se recibió cuerpo de respuesta")
                completion([])
                return
            }

            if let responseText = String(data: data, encoding: .utf8) {
                print("📦 Cuerpo de respuesta:")
                print(responseText)
            } else {
                print("⚠️ No se pudo convertir el cuerpo a texto")
            }

            procesarRespuesta(data: data) { alimentosConIndice in
                completion(alimentosConIndice)
            }
        }.resume()
    }

    // MARK: - Helpers

    private static func construirBody(imagenData: Data, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"foto.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(imagenData)
        body.append("\(lineBreak)--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        return body
    }

    private static func procesarRespuesta(data: Data, completion: @escaping ([AlimentoDetectado]) -> Void) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let segmentos = json["segmentation_results"] as? [[String: Any]] else {
                print("Respuesta no válida o vacía.")
                completion([])
                return
            }

            var alimentosDetectados = Set<AlimentoDetectado>()

            for segmento in segmentos {
                guard let resultados = segmento["recognition_results"] as? [[String: Any]] else { continue }

                let resultadosOrdenados = resultados.sorted {
                    ($0["prob"] as? Double ?? 0) > ($1["prob"] as? Double ?? 0)
                }

                if let mejor = resultadosOrdenados.first,
                   let nombre = mejor["name"] as? String,
                   let familias = mejor["foodFamily"] as? [[String: Any]],
                   let familia = familias.first?["name"] as? String {
                    
                    let alimento = AlimentoDetectado(nombre: nombre, familia: familia, glycemyIndex: 0.0, glycemicLoad: 0.0)
                    alimentosDetectados.insert(alimento)
                }
            }

            let lista = Array(alimentosDetectados)

            GeminiService.shared.completarGlycemyIndex(para: lista) { completados in
                let final = completados.map { alimento in
                    let carbs = 15.0 // ← Puedes cambiarlo si tienes datos reales por alimento
                    let load = (alimento.glycemyIndex * carbs) / 100.0
                    return AlimentoDetectado(
                        nombre: alimento.nombre,
                        familia: alimento.familia,
                        glycemyIndex: alimento.glycemyIndex,
                        glycemicLoad: load
                    )
                }

                let ordenados = final.sorted { $0.glycemyIndex < $1.glycemyIndex }
                completion(ordenados)
            }

        } catch {
            print("Error al parsear JSON: \(error)")
            completion([])
        }
    }

}

// MARK: - Extensión para redimensionar imagen

extension UIImage {
    func reescalar(nuevoAncho: CGFloat) -> UIImage {
        let escala = nuevoAncho / self.size.width
        let nuevoAlto = self.size.height * escala
        let tamañoNuevo = CGSize(width: nuevoAncho, height: nuevoAlto)

        UIGraphicsBeginImageContextWithOptions(tamañoNuevo, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: tamañoNuevo))
        let imagenRedimensionada = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imagenRedimensionada ?? self
    }
}
