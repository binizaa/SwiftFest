//
//  XYChart.swift
//  ChartProj
//
//  Created by Leoni Bernabe on 07/06/25.
//

import SwiftUI
import Charts

struct XYChart: View {
    var body: some View {
        VStack (spacing: 0){
            Text("Niveles de Glucosa")
                .font(.headline)
                .fontWeight(.regular)
            
            Chart(glucoseData) { reading in
                LineMark(
                    x: .value("Fecha", reading.date),
                    y: .value("Nivel de glucosa", reading.level)
                )
                .symbol(Circle())
                .foregroundStyle(.red)
            }
            .modifier(AxisModifier(title: "Línea"))
            .padding()
        }
    }
}

/// Reutilizable para los ejes
struct AxisModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .chartXAxis {
                AxisMarks(values: .automatic()) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day(), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 300)
            .padding()
    }
}

#Preview {
    XYChart()
}

