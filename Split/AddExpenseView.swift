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
    @State private var paidBy: String = "Select"
    @State private var paidFor: String = "Select"
    @State private var date: Date = Date()

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
                    Picker("", selection: $paidBy) {
                        Text("Select").tag("Select")
                        ForEach(participants) { participant in
                            Text(participant.name).tag(participant.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)

                // Paid For
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paid for")
                        .font(.subheadline)
                    Picker("", selection: $paidFor) {
                        Text("Select").tag("Select")
                        ForEach(participants) { participant in
                            Text(participant.name).tag(participant.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
                        paidBy: paidBy,
                        paidFor: paidFor,
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
                .disabled(title.isEmpty || amount.isEmpty || paidBy == "Select" || paidFor == "Select")
            }
            .navigationBarBackButtonHidden()
        }
    }
}
