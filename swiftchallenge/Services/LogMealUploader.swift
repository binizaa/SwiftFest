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
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = imagen.jpegData(compressionQuality: 0.8) else {
            completion([])
            return
        }

        request.httpBody = construirBody(imagenData: imageData, boundary: boundary)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion([])
                return
            }

            guard let data = data else {
                print("No se recibió data")
                completion([])
                return
            }

            let alimentos = procesarRespuesta(data: data)
            completion(alimentos)
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

    private static func procesarRespuesta(data: Data) -> [AlimentoDetectado] {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let segmentos = json["segmentation_results"] as? [[String: Any]] else {
                print("Respuesta no válida o vacía.")
                return []
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
                    let alimento = AlimentoDetectado(nombre: nombre, familia: familia, glycemyIndex: 0.0)
                    alimentosDetectados.insert(alimento)
                }
            }

            return Array(alimentosDetectados)
        } catch {
            print("Error al parsear JSON: \(error)")
            return []
        }
    }
}
