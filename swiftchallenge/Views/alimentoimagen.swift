import SwiftUI
import CoreML
import GoogleGenerativeAI
import AVFoundation
import Speech

class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @Published var transcript: String = ""
    
    private var audioEngine: AVAudioEngine?
        private var request: SFSpeechAudioBufferRecognitionRequest?
        private var task: SFSpeechRecognitionTask?
        private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
    
    init() {
            Task(priority: .background) {
                do {
                    guard recognizer != nil else {
                        throw RecognizerError.nilRecognizer
                    }
                    guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                        throw RecognizerError.notAuthorizedToRecognize
                    }
                    guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                        throw RecognizerError.notPermittedToRecord
                    }
                } catch {
                    speakError(error)
                }
            }
        }
    
    deinit {
        reset()
    }
    
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    func transcribe() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.speakError(RecognizerError.recognizerIsUnavailable)
                return
            }
            
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                
                self.task = recognizer.recognitionTask(with: request) { result, error in
                    let receivedFinalResult = result?.isFinal ?? false
                    let receivedError = error != nil
                    
                    if receivedFinalResult || receivedError {
                        audioEngine.stop()
                        audioEngine.inputNode.removeTap(onBus: 0)
                    }
                    
                    if let result = result {
                        self.speak(result.bestTranscription.formattedString)
                    }
                }
            } catch {
                self.reset()
                self.speakError(error)
            }
        }
    }
    
    func stopTranscribing() {
        reset()
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func speak(_ message: String) {
        DispatchQueue.main.async {
            self.transcript = message
        }
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage = error.message
        } else {
            errorMessage = error.localizedDescription
        }
        DispatchQueue.main.async {
            self.transcript = "<< \(errorMessage) >>"
        }
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var predictionLabel: String = ""
    @State private var ingredients: [String] = []
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var transcribedText: String = ""
    
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
            
            Divider()
                .padding(.vertical)
            
            Text("Transcripción: \(speechRecognizer.transcript)")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .lineLimit(nil)
            
            Button(action: {
                if !isRecording {
                    speechRecognizer.transcribe()
                } else {
                    speechRecognizer.stopTranscribing()
                    
                    transcribedText = speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if !transcribedText.isEmpty && !transcribedText.starts(with: "<<") {
                        predictionLabel = transcribedText
                        fetchIngredients(for: transcribedText)
                    }
                }
                isRecording.toggle()
            }) {
                Text(isRecording ? "Detener grabación" : "Iniciar grabación")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $selectedImage)
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
            let jsonData = try JSONEncoder().encode(savedData)
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

