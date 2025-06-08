//
//  CaptureMealView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct CaptureMealView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    NavigationLink(destination: mealUploader(metodo: metodoDesde(title: optionsToCapture[0].title))) {
                        HCard(selection: optionsToCapture[0])
                    }
                    .buttonStyle(.plain)
                   
                    NavigationLink(destination: mealUploader(metodo: metodoDesde(title: optionsToCapture[1].title))) {
                        HCard(selection: optionsToCapture[1])
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: RegistroPorVozView()) {
                        HCard(selection: optionsToCapture[2])
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: ManualFoodInputView()) {
                        HCard(selection: optionsToCapture[3])
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .navigationBarBackButtonHidden(true)
        }
       
    }
    
    func metodoDesde(title: String) -> MetodoCaptura {
        switch title {
        case "Cámara": return .camara
        case "Galería": return .galeria
        default: return .camara
        }
    }

}

#Preview {
    CaptureMealView()
}

