//
//  PaymentBreakdownView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI
import SwiftData

struct PaymentBreakdownView: View {
    let eventName: String
    let amountPerParticipant: Double
    let totalBillAmount: Double
    let numberOfParticipants: Int
    let tipPercentage: Int
    var modelContext: ModelContext
    let isShare: Bool
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(eventName)
                .font(.title)
                .fontWeight(.bold)
                
                Text("Amount per participant")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ZStack {
                    Image("iconsSaveMoney")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    Text("$\(String(format: "%.2f", amountPerParticipant))")
                        .font(.system(size: 36, weight: .bold))
                        .offset(x: -15, y: 15)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Total bill amount")
                        Spacer()
                        Text("$\(String(format: "%.2f", totalBillAmount))")
                    }
                    
                    HStack {
                        Text("Number of participants")
                        Spacer()
                        Text("\(numberOfParticipants)")
                    }
                    
                    HStack {
                        Text("Tip percentage")
                        Spacer()
                        Text("\(tipPercentage)%")
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Amount per participant")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", amountPerParticipant))")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                Spacer()
                
            Button("Go to main") {
                            let newSplit = Split(
                                eventName: eventName,
                                totalAmount: totalBillAmount,
                                amountPerParticipant: amountPerParticipant,
                                isSplit: !isShare,
                                participants: isShare ? (0..<numberOfParticipants).map { _ in String(UUID().uuidString.prefix(2)) } : nil
                            )
                            modelContext.insert(newSplit)
                            dismissAction()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                }
            
        
    
}

