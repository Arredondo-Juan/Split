//
//  PaymentBreakdownView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct PaymentBreakdownView: View {
    let eventName: String
    let amountPerParticipant: Double
    let totalBillAmount: Double
    let numberOfParticipants: Int
    let tipPercentage: Int
    
    @Environment(\.presentationMode) var presentationMode
    
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
                presentationMode.wrappedValue.dismiss()
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
    }
}

#Preview {
    PaymentBreakdownView(eventName: "Friday Night Out", amountPerParticipant: 94.58, totalBillAmount: 567.5, numberOfParticipants: 6, tipPercentage: 15)
}
