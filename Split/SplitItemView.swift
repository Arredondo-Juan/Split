//
//  SplitItemView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct SplitItemView: View {
    let split: Split
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(split.eventName)
                    .font(.headline)
                Spacer()
                Text(split.isSplit ? "Split" : "Share")
                    .font(.footnote)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(split.isSplit ? Color.green : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Text("Total: $\(String(format: "%.2f", split.totalAmount))")
                .foregroundColor(.gray)
            if split.isSplit {
                Text("Each: $\(String(format: "%.2f", split.amountPerParticipant))")
                    .foregroundColor(.gray)
            } else if let participants = split.participants {
                HStack {
                    Text("Participants")
                    ForEach(participants, id: \.self) { participant in
                        Text(participant)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
