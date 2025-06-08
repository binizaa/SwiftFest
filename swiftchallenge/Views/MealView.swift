//
//  MealView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI


struct MealView: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealCard(meal: meal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Historial de comidas")

        }
    }
}

#Preview {
    MealView()
}

// Esto va en Models
struct Nutrient: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
}

struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let imageName: String
    let nutrients: [Nutrient]
}

let meals = [
    Meal(
        name: "Sushi",
        calories: 244,
        imageName: "sushi",
        nutrients: [
            Nutrient(name: "Calories", amount: "244"),
            Nutrient(name: "Proteins", amount: "19g"),
            Nutrient(name: "Fats", amount: "5g"),
            Nutrient(name: "Carbs", amount: "30g")
        ]
    ),
    Meal(
        name: "Pancakes",
        calories: 300,
        imageName: "pancakes",
        nutrients: [
            Nutrient(name: "Calories", amount: "300"),
            Nutrient(name: "Proteins", amount: "20g"),
            Nutrient(name: "Fats", amount: "15g"),
            Nutrient(name: "Carbs", amount: "15g")
        ]
    ),
    
    Meal(name: "Sopa de verduras", calories: 120, imageName: "sopa",
         nutrients: [
         Nutrient(name: "Calories", amount: "300"),
         Nutrient(name: "Proteins", amount: "20g"),
         Nutrient(name: "Fats", amount: "15g"),
         Nutrient(name: "Carbs", amount: "15g")
                                                                                                ])
]


