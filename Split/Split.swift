//
//  Split.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import Foundation
import SwiftData

@Model
final class Split {
    var id: UUID
    var eventName: String
    var totalAmount: Double
    var amountPerParticipant: Double
    var isSplit: Bool
    var participants: [String]?
    var isDone: Bool
    
    init(eventName: String, totalAmount: Double, amountPerParticipant: Double, isSplit: Bool, participants: [String]? = nil) {
        self.id = UUID()
        self.eventName = eventName
        self.totalAmount = totalAmount
        self.amountPerParticipant = amountPerParticipant
        self.isSplit = isSplit
        self.participants = participants
        self.isDone = false
    }
}
