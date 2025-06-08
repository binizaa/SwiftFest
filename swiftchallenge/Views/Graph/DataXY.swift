import Foundation

struct GlucoseReading: Identifiable {
    let id = UUID()
    let date: Date
    let level: Double
}

let glucoseData: [GlucoseReading] = [
    GlucoseReading(date: Date().addingTimeInterval(-3600 * 6), level: 110),
    GlucoseReading(date: Date().addingTimeInterval(-3600 * 4), level: 130),
    GlucoseReading(date: Date().addingTimeInterval(-3600 * 3), level: 125),
    GlucoseReading(date: Date().addingTimeInterval(-3600 * 2), level: 115),
    GlucoseReading(date: Date().addingTimeInterval(-3600), level: 140),
    GlucoseReading(date: Date(), level: 120)
]


