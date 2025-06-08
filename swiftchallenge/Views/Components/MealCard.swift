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
                .scaledToFill()
                .frame(height: 180)
//                .clipped()
//                .cornerRadius(12)

            HStack {
                VStack(alignment: .leading) {
                    Text(meal.name)
                        .font(.custom("Poppins-Bold", size: 20))
                    Text("\(meal.calories) Cal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(){
            RoundedRectangle(cornerRadius: 16)
                   .fill(.ultraThinMaterial)
                   .background(.gray.opacity(0.15))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
        
        
    }
}


#Preview {
    MealCard(meal: meals[1])
}
