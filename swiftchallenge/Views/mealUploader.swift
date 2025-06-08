//
//  mealUploader.swift
//  swiftchallenge
//
//  Created by Biniza Ruiz on 08/06/25.
//

import SwiftUI
import PhotosUI

enum MetodoCaptura {
    case camara, galeria
}

struct mealUploader: View {
    let metodo: MetodoCaptura

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var cargando = false
    @State private var alimentosDetectados: [AlimentoDetectado] = []
    @State private var mostrarCamera = false
    @State private var navegar = false
    @State private var alimentosComoFoodData: [FoodData] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: selectedImage)
                }
                
                Button("Analizar") {
                    if let imagen = selectedImage {
                        cargando = true
                        alimentosDetectados = []
                        
                        LogMealUploader.enviarImagen(imagen) { alimentos in
                            DispatchQueue.main.async {
                                alimentosDetectados = alimentos
                                alimentosComoFoodData = alimentos.map { alimento in
                                    FoodData(
                                        Family: alimento.familia,
                                        Name: alimento.nombre,
                                        GlycemicIndex: alimento.glycemyIndex,
                                        glycemicLoad: alimento.glycemicLoad ?? 0.0
                                    )
                                }
                                cargando = false
                                navegar = true
                            }
                        }
                    }
                }
                .disabled(selectedImage == nil || cargando)
                
                if cargando {
                    ProgressView("Analizando imagen...")
                        .padding()
                }
                
                if !alimentosDetectados.isEmpty {
                    NavigationLink(destination: PlateSelectionList(mealsi: alimentosComoFoodData)) {
                        Text("Ver Plan de Alimentación")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                }
            }
            .padding()
            .sheet(isPresented: $mostrarCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .onAppear {
                switch metodo {
                case .camara:
                    mostrarCamera = true
                case .galeria:
                    break
                    
                }
            }
            .photosPicker(isPresented: Binding(
                get: { metodo == .galeria && selectedImage == nil },
                set: { _ in }
            ), selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                        alimentosDetectados = []
                    }
                }
            }
            
        }
    }
}

#Preview {
    mealUploader(metodo:.galeria)
}
