//
//  SpeechRecognizer.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 08/06/25.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))!
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    @Published var transcripcion = ""
    @Published var estaEscuchando = false

    override init() {
        super.init()
        speechRecognizer.delegate = self
    }

    func solicitarPermisos(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }

    func comenzarEscucha() {
        transcripcion = ""
        estaEscuchando = true

        request = SFSpeechAudioBufferRecognitionRequest()

        let node = audioEngine.inputNode
        guard let request = request else { return }

        request.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                self.transcripcion = result.bestTranscription.formattedString
            }

            if error != nil || (result?.isFinal ?? false) {
                self.detenerEscucha()
            }
        }

        let format = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    func detenerEscucha() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
        estaEscuchando = false
    }
}
