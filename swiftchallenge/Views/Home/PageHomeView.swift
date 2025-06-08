//
//  HomeView.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 07/06/25.
//

import SwiftUI

struct PageHomeView: View {
    @State private var selectedMeal: Meal? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    HeaderView()
                        .padding(.horizontal)
                    
                    
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
                    
                    LazyVStack{
                        ForEach(meals) { meal in
                            
                            Button {
                                selectedMeal = meal
                            } label: {
                                MealCard(meal: meal)
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
    PageHomeView()
}

