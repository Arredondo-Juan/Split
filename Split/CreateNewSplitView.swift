//
//  CreateNewSplitView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI
import SwiftData

struct Participant: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let color: Color
}

struct CreateNewSplitView: View {
    @Environment(\.dismiss) var dismiss
    var modelContext: ModelContext
    
    @State private var eventName = ""
    @State private var numberOfParticipants = ""
    @State private var totalBillAmount = ""
    @State private var tipPercentage = ""
    @State private var selectedCurrency = "USD"
    @State private var selectedMode = 0  // 0 = Split, 1 = Share
    
    @State private var participantName = ""
    @State private var participants: [Participant] = []  // For adding participants in Share mode
    @State private var navigateToPaymentBreakdown = false
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    var isFormValid: Bool {
        if selectedMode == 0 {
            return !eventName.isEmpty &&
            !numberOfParticipants.isEmpty &&
            !totalBillAmount.isEmpty &&
            !tipPercentage.isEmpty &&
            Int(numberOfParticipants) != nil &&
            Double(totalBillAmount) != nil &&
            Int(tipPercentage) != nil
        } else {
            return !eventName.isEmpty && !participants.isEmpty
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Picker for Split or Share mode
                Picker("Mode", selection: $selectedMode) {
                    Text("Split").tag(0)
                    Text("Share").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Conditionally show fields based on the selected mode
                if selectedMode == 0 {
                    // Split mode fields
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
                    
                } else if selectedMode == 1 {
                    // Share mode fields
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Event Name")
                            .font(.subheadline)
                        TextField("E.g: Night at Noa's Bar", text: $eventName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Pick Currency")
                            .font(.subheadline)
                        Picker("Currency", selection: $selectedCurrency) {
                            Text("USD").tag("USD")
                            Text("EURO").tag("EURO")
                            Text("GBP").tag("GBP")
                            Text("GEL").tag("GEL")
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Text("Add participants")
                            .font(.subheadline)
                        HStack {
                            TextField("Enter Name", text: $participantName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                addParticipant()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        // List of added participants
                        if !participants.isEmpty {
                            ScrollView {
                                ForEach(participants) { participant in
                                    HStack {
                                        Circle()
                                            .fill(participant.color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text(participant.initials)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 16, weight: .semibold))
                                            )
                                        
                                        Text(participant.name)
                                            .font(.body)
                                            .padding(.leading, 8)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Button action
                Button(action: {
                    navigateToPaymentBreakdown = true
                }) {
                    Text(selectedMode == 0 ? "Split" : "Create Share")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.customPurple : Color.customPalePurple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding()
            }
            .navigationTitle("Create new split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToPaymentBreakdown) {
                PaymentBreakdownView(
                    eventName: eventName,
                    amountPerParticipant: calculateAmountPerParticipant(),
                    totalBillAmount: Double(totalBillAmount) ?? 0.0,
                    numberOfParticipants: Int(numberOfParticipants) ?? 0,
                    tipPercentage: Int(tipPercentage) ?? 0,
                    modelContext: modelContext,
                    isShare: selectedMode == 1,
                    dismissAction: { dismiss() }
                )
            }
        }
    }
    
    private func addParticipant() {
        guard !participantName.isEmpty else { return }
        let initials = participantName.components(separatedBy: " ")
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
        let color = colors.randomElement() ?? .gray
        let newParticipant = Participant(name: participantName, initials: initials, color: color)
        participants.append(newParticipant)
        participantName = ""
    }
    
    // Function to calculate amount per participant in Split mode
    private func calculateAmountPerParticipant() -> Double {
        let billAmount = Double(totalBillAmount) ?? 0.0
        let participants = Int(numberOfParticipants) ?? 1
        let tipAmount = billAmount * (Double(tipPercentage) ?? 0.0) / 100
        return (billAmount + tipAmount) / Double(participants)
    }
}

#Preview {
    CreateNewSplitView(modelContext: ModelContext(try! ModelContainer(for: Split.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
}
