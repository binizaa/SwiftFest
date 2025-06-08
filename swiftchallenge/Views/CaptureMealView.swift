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
                   
                    ForEach(optionsToCapture) { section in
                        NavigationLink(destination: mealUploader(metodo: metodoDesde(title: section.title))) {
                            HCard(selection: section)
                        }

                        .buttonStyle(.plain)
                    }
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
        default: return .galeria 
        }
    }

}

#Preview {
    CaptureMealView()
}

