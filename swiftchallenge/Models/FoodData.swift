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
    let GlycemicIndex: Int
}

func getColor(glucymeIndex: Int) -> Color {
    if glucymeIndex < 5 {
        return .green
    } else if glucymeIndex < 15 {
        return .orange
    } else {
        return .red
    }
}
