//
//  ShareDetailsView.swift
//  Split
//
//  Created by Juan Arredondo on 10/5/24.
//

import SwiftUI
import SwiftData

struct ShareDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext: ModelContext
    @Query private var participants: [Participant]
    @State private var navigateToAddExpense = false

    var eventName: String
    var eventId: UUID

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
                    Text(eventName)
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Settings action placeholder
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
                .padding()

                // Total Expenses Card
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Expenses")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("$ 0.00")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                    Image("iconsReceipt2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Segmented Control for Expenses and Balances
                Picker("", selection: .constant(0)) {
                    Text("Expenses").tag(0)
                    Text("Balances").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // Participants List
                if participants.isEmpty {
                    Spacer()
                    Text("No Participants yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(participants.filter { $0.eventId == eventId }) { participant in
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

                Spacer()

                // Add Expense Button
                Button(action: {
                    navigateToAddExpense = true
                }) {
                    Text("Add Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

            }
            .navigationDestination(isPresented: $navigateToAddExpense) {
                AddExpenseView(participants: participants.filter { $0.eventId == eventId })
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ShareDetailsView(eventName: "Trip in Italy", eventId: UUID())
}
