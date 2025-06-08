//
//  PieChart.swift
//  ChartProj
//
//  Created by Leoni Bernabe on 07/06/25.
//

import SwiftUI
import Charts

struct PieChart: View {
    var body: some View {
        VStack (spacing: 0){
            Text("Indice de Glucosa")
                .font(.headline)
            
            Chart {
                ForEach(mealSummary) { category in
                    SectorMark(
                        angle: .value("Cantidad", category.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 6
                    )
                    .foregroundStyle(by: .value("Tipo", category.tag))
                }
            }
            .frame(height: 300)
            .padding()
            .chartForegroundStyleScale([
                "alto": .red,
                "bajo": .green,
                "medio": .yellow,
            ])
        }
    }
}

#Preview {
    PieChart()
}

