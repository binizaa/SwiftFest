//
//  MealCard.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct MealCard: View {
    var meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(meal.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)

            HStack {
                VStack(alignment: .leading) {
                    Text(meal.name)
                        .font(.custom("Poppins-Bold", size: 20))
                    Text("\(meal.calories) Cal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}


#Preview {
    MealDetailView(meal: meals[1])
}
