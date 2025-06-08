//
//  MealDeatil.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(meal.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(meal.name)
                        .font(.custom("Poppins-Bold", size: 28))
                        .bold()
                    
                    Text("\(meal.calories) Cal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 25) {
                        ForEach(meal.nutrients) { nutrient in
                            VStack() {
                                Text(nutrient.amount)
                                    .font(.headline)
                                Text(nutrient.name)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}


#Preview {
    MealDetailView(meal: meals[0])
}
