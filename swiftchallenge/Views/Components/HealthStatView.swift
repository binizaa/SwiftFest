//
//  Health.swift
//  swiftchallenge
//
//  Created by Wendy Sanchez Cortes on 08/06/25.
//

import SwiftUI

//para la glucosa

struct HealthStatView: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption)
                .foregroundColor(.gray)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
