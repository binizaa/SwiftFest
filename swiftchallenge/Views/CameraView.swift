//
//  CameraView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 08/06/25.
//

import SwiftUI

#Preview {
    CameraView()
}

struct CameraView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("No se ha seleccionado imagen")
                    .foregroundColor(.gray)
            }

            Button("Tomar Foto") {
                showCamera = true
            }
            .padding()
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
    }
}

