//
//  FoodData.swift
//  swiftchallenge
//
//  Created by Leoni Bernabe on 08/06/25.
//

import SwiftUI

struct FoodData: Identifiable {
    let id = UUID()
    let Family: String
    let Name: String
    let GlycemicIndex: Double
    var glycemicLoad: Double
}

func getColor(glucymeIndex: Double) -> Color {
    if glucymeIndex <= 55 {
        return .green
    } else if glucymeIndex <= 69 {
        return .orange
    } else {
        return .red
    }
}

var meales: [FoodData] = [
    FoodData(Family: "Vegetable", Name: "Broccoli", GlycemicIndex: 10, glycemicLoad: 15),
    FoodData(Family: "Fruit", Name: "Apple", GlycemicIndex: 8, glycemicLoad: 14),
    FoodData(Family: "Grain", Name: "White Rice", GlycemicIndex: 7, glycemicLoad: 13),
    FoodData(Family: "Protein", Name: "Chicken Breast", GlycemicIndex: 0, glycemicLoad: 0),
    FoodData(Family: "Dairy", Name: "Whole Milk", GlycemicIndex: 18, glycemicLoad: 26)
]
