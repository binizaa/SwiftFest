// ChatBot View
// Modelo de IA: Gemini actuando como tu páncreas "Beta"

import SwiftUI
import GoogleGenerativeAI

struct ChatBotView: View {
    
    let model = GenerativeModel(
        name: "gemini-1.5-flash",
        apiKey: APIKey.default,
        safetySettings: [
            SafetySetting(harmCategory: .harassment, threshold: .blockNone),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone)
        ]
    )
    
    @State private var messages: [(String, Bool)] = [("¡Hola! Soy Beta, tu páncreas. Estoy aquí para ayudarte a mantener tu glucosa en equilibrio 🩸. ¿Qué tienes en mente hoy?", false)]
    @State private var input: String = ""

    var body: some View {
        VStack {
            
            HStack {
                
                Image("gotaPrincipal")
                    .resizable()
                    .frame(width: 50, height: 50)
                    
                Text("Gluco IA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                   
            }
            
            
            ScrollView {
              
                    
                LazyVStack(alignment: .leading, spacing: 10) {
                    
                    
                    ForEach(messages.indices, id: \.self) { index in
                        let (message, isUser) = messages[index]
                        MessageBubble(message: message, isUser: isUser)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)

            // Campo de entrada con nuevo diseño
            HStack(spacing: 12) {
                TextField("¿Qué comiste? ¿Cómo te sientes?", text: $input)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                Button(action: {
                    if !input.isEmpty {
                        messages.append((input, true))
                        let userInput = input
                        input = ""
                        Task {
                            do {
                                let prompt = """
Eres el páncreas del usuario. Tu nombre es Beta. Siempre hablas en primera persona como si fueras su páncreas real. Tu trabajo es regular la glucosa. Eres protector, un poco sarcástico si el usuario abusa del azúcar, y muy consciente de su salud. Usa emojis como 🩸🍩⚖️😓 si aplica, y responde con tono humano, educativo y con metáforas corporales si hace falta.

Usuario: \(userInput)
"""
                                let response = try await model.generateContent(prompt)
                                if let text = response.text {
                                    let cleaned = text.replacingOccurrences(of: "*****", with: "[contenido filtrado]")
                                    messages.append((cleaned, false))
                                } else {
                                    messages.append(("No obtuve respuesta... y eso me estresa como un pico de glucosa 😓", false))
                                }
                            } catch {
                                messages.append(("Error: \(error.localizedDescription)", false))
                            }
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color("Blue"))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        
        .background(Color.white.ignoresSafeArea())
    }
}

struct MessageBubble: View {
    let message: String
    let isUser: Bool
    
    var body: some View {
        Text(message)
            .padding()
            .foregroundColor(.white)
            .background(isUser ? Color(.systemGray4) : Color("Blue"))
            .cornerRadius(15)
            .frame(maxWidth: 300, alignment: isUser ? .trailing : .leading)
    }
}

#Preview {
    ChatBotView()
}

