import SwiftUI

struct MealCategory: Identifiable {
    let id = UUID()
    let tag: String
    let count: Int
}

let mealSummary: [MealCategory] = [
    MealCategory(tag: "alto", count: 5),
    MealCategory(tag: "medio", count: 3),
    MealCategory(tag: "bajo", count: 2)
]

let colorMap: [String: Color] = [
    "alto": .red,
    "medio": .yellow,
    "bajo": .green
]

