//
//  PlateSelectionList.swift
//  swiftchallenge
//
//  Created by Leoni Bernabe on 08/06/25.
//

import SwiftUI

struct PlateSelectionList: View {
    @State private var meals: [FoodData] = [
        FoodData(Family: "Vegetable", Name: "Broccoli", GlycemicIndex: 10),
        FoodData(Family: "Fruit", Name: "Apple", GlycemicIndex: 8),
        FoodData(Family: "Grain", Name: "White Rice", GlycemicIndex: 7),
        FoodData(Family: "Protein", Name: "Chicken Breast", GlycemicIndex: 0),
        FoodData(Family: "Dairy", Name: "Whole Milk", GlycemicIndex: 18)
    ]

    var body: some View {
        NavigationStack {
            VStack{
                List {
                    Section {
                        VStack(alignment: .center) {
                            Text("Meal Plan")
                                .font(.largeTitle)
                                .padding(.top)
                            
                            Text("Es hora de planificar tu plato de hoy.")
                                .foregroundStyle(.gray)
                            
                            Image("gotaChart")
                                .resizable()
                                .frame(width: 300, height: 300)
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        //                .listRowInsets(EdgeInsets()) // quitar márgenes de celda
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        
                    }
                    
                    ForEach(meals, id: \.id) { meal in
                        PlateSelectionView(
                            name: meal.Name,
                            family: meal.Family,
                            color: getColor(glucymeIndex: meal.GlycemicIndex)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .frame(height: 70)
                    }
                    .onDelete { indexSet in
                        meals.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                
                Spacer(minLength: 10)
                
                NavigationLink(destination: HomeView()) {
                    Text("Ir a detalles")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}


#Preview {
    PlateSelectionList()
}
