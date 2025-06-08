//
//  MealView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI


//
//  HomeView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct MealView: View {
    @State private var selectedMeal: Meal? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 10) {
                    
                    HStack{
                        Spacer()
                        GlucoseSummaryView()
                        Spacer()
                    }
                    .
                    padding()
                    
                    Divider()
                    
    
                    Text("Tus estadísticas")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TabView {
                        XYChart()
                        PieChart()
                    }
                    .frame(width: 380, height: 450)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .padding(.vertical)
                    
                    
                    Divider()
                    
                    Text("Past Meals")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    LazyVStack (spacing: 20){
                        ForEach(meals) { meal in
                            
                            Button {
                                selectedMeal = meal
                            } label: {
                                MealCard(meal: meal)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .sheet(item: $selectedMeal) { meal in
                                MealDetailView(meal: meal)
                            }
                    
                }
            }
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
    )
]


struct GlucoseSummaryView: View {
    var body: some View {
        HStack(spacing: 16) {
            GlucoseCard(days: 07, average: 110)
            GlucoseCard(days: 14, average: 116)
            GlucoseCard(days: 30, average: 113)
        }
        .padding(.horizontal)
    }
}

struct GlucoseCard: View {
    let days: Int
    let average: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("\(days) days")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.2))
                .clipShape(Capsule())

            VStack(spacing: 2) {
                Text("Average")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(average)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("mg/dL")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(width: 100)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
