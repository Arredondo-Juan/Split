//
//  CreateNewSplitView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct CreateNewSplitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var splits: [Split]
    @State private var eventName = ""
    @State private var numberOfParticipants = ""
    @State private var totalBillAmount = ""
    @State private var tipPercentage = ""
    @State private var selectedCurrency = "USD"
    @State private var selectedMode = 0
    
    @State private var navigateToPaymentBreakdown = false
    
    var isFormValid: Bool {
        !eventName.isEmpty &&
        !numberOfParticipants.isEmpty &&
        !totalBillAmount.isEmpty &&
        !tipPercentage.isEmpty &&
        Int(numberOfParticipants) != nil &&
        Double(totalBillAmount) != nil &&
        Int(tipPercentage) != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Create new split")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                Picker("Mode", selection: $selectedMode) {
                    Text("Split").tag(0)
                    Text("Share").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event Name")
                        .font(.subheadline)
                    TextField("E.g: Night at Noa's Bar", text: $eventName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Number of participants")
                        .font(.subheadline)
                    TextField("Enter number", text: $numberOfParticipants)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Text("Total bill amount")
                        .font(.subheadline)
                    HStack {
                        TextField("Enter amount", text: $totalBillAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Picker("Currency", selection: $selectedCurrency) {
                            Text("USD").tag("USD")
                            Text("EURO").tag("EURO")
                            Text("GBP").tag("GBP")
                            Text("GEL").tag("GEL")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Text("Tip Percentage")
                        .font(.subheadline)
                    TextField("Enter amount", text: $tipPercentage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    navigateToPaymentBreakdown = true
                }) {
                    Text(selectedMode == 0 ? "Split" : "Share")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.customPurple : Color.customPalePurple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding()
                .navigationDestination(isPresented: $navigateToPaymentBreakdown) {
                    PaymentBreakdownView(
                        eventName: eventName,
                        amountPerParticipant: calculateAmountPerParticipant(),
                        totalBillAmount: Double(totalBillAmount) ?? 0.0,
                        numberOfParticipants: Int(numberOfParticipants) ?? 0,
                        tipPercentage: Int(tipPercentage) ?? 0,
                        splits: $splits,
                        isShare: selectedMode == 1
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func calculateAmountPerParticipant() -> Double {
        let billAmount = Double(totalBillAmount) ?? 0.0
        let participants = Int(numberOfParticipants) ?? 1
        let tipAmount = billAmount * (Double(tipPercentage) ?? 0.0) / 100
        return (billAmount + tipAmount) / Double(participants)
    }
}

#Preview {
    CreateNewSplitView(splits: .constant([]))
}
