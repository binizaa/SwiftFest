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
    case profile = "Profile"
    case chat = "Chat"
    case register = "Register"
    
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .chat:
            return "message"
        case .profile:
            return "person.circle"
        case .register:
            return "plus"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}

