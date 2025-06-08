import Foundation
import UIKit

class LogMealUploader {
    static func enviarImagen(_ imagen: UIImage) {
        guard let url = URL(string: "https://api.logmeal.com/v2/image/segmentation/complete/v1.0?language=spa") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer 85951b4a319cea3650f78c1d4438e334c23244fe", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = imagen.jpegData(compressionQuality: 0.8) else { return }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"foto.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No se recibió data")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let segmentos = json["segmentation_results"] as? [[String: Any]] {

                    var alimentosMostrados = Set<String>()

                    for segmento in segmentos {
                        guard let resultados = segmento["recognition_results"] as? [[String: Any]] else { continue }

                        let resultadosOrdenados = resultados.sorted {
                            ($0["prob"] as? Double ?? 0) > ($1["prob"] as? Double ?? 0)
                        }

                        // Tomar el de mayor probabilidad
                        if let mejor = resultadosOrdenados.first,
                           let nombre = mejor["name"] as? String,
                           !alimentosMostrados.contains(nombre) {

                            alimentosMostrados.insert(nombre)
                        }
                    }

                    print(alimentosMostrados)
                } else {
                    print("Respuesta no válida o vacía.")
                }
            } catch {
                print("Error al parsear JSON: \(error)")
            }
        }.resume()
    }
}
