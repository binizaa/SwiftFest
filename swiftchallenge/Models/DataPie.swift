import SwiftUI

struct MealCategory: Identifiable {
    let id = UUID()
    let tag: String
    let count: Int
}

var mealSummary: [MealCategory] = [
    MealCategory(tag: "alto", count: 5),
    MealCategory(tag: "medio", count: 3),
    MealCategory(tag: "bajo", count: 2),
    MealCategory(tag: "alto", count: 10),
]

let colorMap: [String: Color] = [
    "alto": .red,
    "medio": .yellow,
    "bajo": .green
]

func agruparMealCategories(_ categorias: [MealCategory]) -> [MealCategory] {
    var acumulado: [String: Int] = [:]
    
    for categoria in categorias {
        acumulado[categoria.tag, default: 0] += categoria.count
    }

    return acumulado.map { tag, total in
        MealCategory(tag: tag, count: total)
    }
}
