//
//  Home.swift
//  CurvedTabBar
//
//  Created by Leoni Bernabe on 07/06/25.
//

import SwiftUI

struct HomeView: View {
    /// View properties
    @State private var activeTab: Tab = .home
    @Namespace private var animation

    var body: some View {
        
        VStack(spacing: 0){
            TabView(selection: $activeTab) {
                Text("Home")
                    .tag(Tab.home)
                    /// Hiding Native Tab Bar
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Service")
                    .tag(Tab.services)
                    /// Hiding Native Tab Bar
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Partner")
                    .tag(Tab.partners)
                    /// Hiding Native Tab Bar
                    .toolbar(.hidden, for: .tabBar)
                
                Text("Activity")
                    .tag(Tab.activity)
                    /// Hiding Native Tab Bar
                    .toolbar(.hidden, for: .tabBar)
            }
            
            CustomTabBar()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color("Blue"), _ inactiveTint: Color = Color("Blue")) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: tint,
                    inactieveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            Rectangle()
                .fill(Color.gray)
                .opacity(0.1)
                .frame(height: 80)
                .frame(width: 345)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        })
        /// Adding animations
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

struct TabItem: View {
    var tint: Color
    var inactieveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactieveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            activeTab = tab
        }
    }
}

#Preview {
    ContentView()
}

