//
//  Participant.swift
//  Split
//
//  Created by Juan Arredondo on 10/5/24.
//

import SwiftUI
import SwiftData

@Model
final class Participant {
    var id: UUID
    var name: String
    var initials: String
    var colorHex: String
    var eventId: UUID  // Link to a specific event

    init(name: String, initials: String, colorHex: String, eventId: UUID) {
        self.id = UUID()
        self.name = name
        self.initials = initials
        self.colorHex = colorHex
        self.eventId = eventId
    }
}


extension Participant {
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}
