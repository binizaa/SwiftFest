//
//  Tab.swift
//  CurvedTabBar
//
//  Created by Leoni Bernabe on 07/06/25.
//

import SwiftUI

/// App Tab's
enum Tab: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case activity = "Activity"
    
    var systemImage: String {
        switch self {
        case .services:
            return "envelope.open.badge.clock"
        case .home:
            return "house"
        case .activity:
            return "bell"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}

