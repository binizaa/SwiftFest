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
            Text("Indice de Glucosaa")
                .font(.title)
                .fontWeight(.regular)
            
            Chart {
                ForEach(mealSummary) { category in
                    SectorMark(
                        angle: .value("Cantidad", category.count),
                        innerRadius: .ratio(0.7),
                        angularInset: 2
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

