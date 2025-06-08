//
//  PlateSelectionList.swift
//  swiftchallenge
//
//  Created by Leoni Bernabe on 08/06/25.
//

import SwiftUI

struct PlateSelectionList: View {
    
    @State var mealsi: [FoodData]

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
                            
                            Text("Tu proxima pico aproximado será de ")
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        //                .listRowInsets(EdgeInsets()) // quitar márgenes de celda
                        .background(Color.clear)
                        .listRowSeparator(.hidden)
                        
                    }
                    
                    ForEach(mealsi.sorted(by: { $0.GlycemicIndex < $1.GlycemicIndex }), id: \.id)  { meal in
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
                        mealsi.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                
                Spacer(minLength: 10)
                
                NavigationLink(destination: CaptureMealView()) {
                    Text("Registrar mi Comida")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    PlateSelectionList(mealsi: meales)
}
