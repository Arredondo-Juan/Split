//
//  Split.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import Foundation

struct Split: Identifiable {
    let id = UUID()
    let eventName: String
    let totalAmount: Double
    let amountPerParticipant: Double
    let isSplit: Bool
    let participants: [String]?
}
