//
//  AddExpenseView.swift
//  Split
//
//  Created by Juan Arredondo on 10/5/24.
//

import SwiftUI
import SwiftData

@Model
final class Expense {
    var id: UUID
    var title: String
    var amount: Double
    var currency: String
    var paidBy: String
    var paidFor: String
    var date: Date

    init(title: String, amount: Double, currency: String, paidBy: String, paidFor: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.currency = currency
        self.paidBy = paidBy
        self.paidFor = paidFor
        self.date = date
    }
}

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedCurrency: String = "USD"
    @State private var paidByParticipants: [ParticipantAmount] = []
    @State private var paidForParticipants: [ParticipantAmount] = []
    @State private var date: Date = Date()
    @State private var showPaidBySheet = false
    @State private var showPaidForSheet = false

    var participants: [Participant]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header Section
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("Add Expense")
                        .font(.headline)
                    Spacer()
                }
                .padding()

                // Expense Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.subheadline)
                    TextField("Lunch at Pizzarony", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // Amount
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.subheadline)
                    HStack {
                        TextField("$ 0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Picker("Currency", selection: $selectedCurrency) {
                            Text("USD").tag("USD")
                            Text("EURO").tag("EURO")
                            Text("GBP").tag("GBP")
                            Text("GEL").tag("GEL")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .padding(.horizontal)

                // Paid By
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paid By")
                        .font(.subheadline)
                    Button(action: {
                        showPaidBySheet = true
                    }) {
                        HStack {
                            if paidByParticipants.isEmpty {
                                Text("Select")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(paidByParticipants, id: \.participant.id) { participantAmount in
                                    Circle()
                                        .fill(participantAmount.participant.color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text(participantAmount.participant.initials)
                                                .foregroundColor(.white)
                                                .font(.system(size: 12, weight: .semibold))
                                        )
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showPaidBySheet) {
                        PaidBySelectionView(participants: participants, selectedParticipants: $paidByParticipants, dismissAction: { showPaidBySheet = false })
                    }
                }
                .padding(.horizontal)

                // Paid For
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paid For")
                        .font(.subheadline)
                    Button(action: {
                        showPaidForSheet = true
                    }) {
                        HStack {
                            if paidForParticipants.isEmpty {
                                Text("Select")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(paidForParticipants, id: \.participant.id) { participantAmount in
                                    Circle()
                                        .fill(participantAmount.participant.color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text(participantAmount.participant.initials)
                                                .foregroundColor(.white)
                                                .font(.system(size: 12, weight: .semibold))
                                        )
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showPaidForSheet) {
                        PaidBySelectionView(participants: participants, selectedParticipants: $paidForParticipants, dismissAction: { showPaidForSheet = false })
                    }
                }
                .padding(.horizontal)

                // Date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date")
                        .font(.subheadline)
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal)

                Spacer()

                // Save Button
                Button(action: {
                    let newExpense = Expense(
                        title: title,
                        amount: Double(amount) ?? 0.0,
                        currency: selectedCurrency,
                        paidBy: paidByParticipants.map { $0.participant.name }.joined(separator: ", "),
                        paidFor: paidForParticipants.map { $0.participant.name }.joined(separator: ", "),
                        date: date
                    )
                    modelContext.insert(newExpense)
                    dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .disabled(title.isEmpty || amount.isEmpty || paidByParticipants.isEmpty || paidForParticipants.isEmpty)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct PaidBySelectionView: View {
    let participants: [Participant]
    @Binding var selectedParticipants: [ParticipantAmount]
    var dismissAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Paid By")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
                .padding()
            }

            ScrollView {
                ForEach(participants) { participant in
                    VStack(alignment: .leading) {
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
                            if let index = selectedParticipants.firstIndex(where: { $0.participant.id == participant.id }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.purple)
                                TextField("Amount", text: $selectedParticipants[index].amount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 100)
                            } else {
                                Button(action: {
                                    selectedParticipants.append(ParticipantAmount(participant: participant, amount: ""))
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            Spacer()
            Button(action: {
                dismissAction()
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

struct ParticipantAmount: Identifiable {
    let id = UUID()
    let participant: Participant
    var amount: String
}
