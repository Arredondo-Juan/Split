//
//  ContentView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.customPurple]
    }
    @Environment(\.modelContext) private var modelContext
    @Query private var splits: [Split]
    
    @State private var selectedTab: String = "All"
    @State private var activeSegment: String = "Active"
    @State private var isCreateSplitPresented: Bool = false
    
    var filteredSplits: [Split] {
        splits.filter { split in
            (selectedTab == "All" || (selectedTab == "Splits" && split.isSplit) || (selectedTab == "Shares" && !split.isSplit)) &&
            (activeSegment == "Active" ? !split.isDone : split.isDone)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("All").tag("All")
                    Text("Splits").tag("Splits")
                    Text("Shares").tag("Shares")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if filteredSplits.isEmpty {
                    Spacer()
                    
                    VStack {
                        Image("iconsReceipt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        Text("No Splits created yet")
                            .font(.headline)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                } else {
                    List {
                        ForEach(filteredSplits) { split in
                            SplitItemView(split: split)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        split.isDone.toggle()
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }
                                    .tint(.green)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteSplit(split)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Button(action: {
                    isCreateSplitPresented = true
                }) {
                    Text("Create Split")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customPurple)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Splits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("", selection: $activeSegment) {
                        Text("Active").tag("Active")
                        Text("Done").tag("Done")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 150)
                    .offset(y: 45)
                }
            }
            .fullScreenCover(isPresented: $isCreateSplitPresented) {
                CreateNewSplitView(modelContext: modelContext)
            }
        }
    }
    
    private func deleteSplit(_ split: Split) {
        modelContext.delete(split)
    }
}

#Preview {
    MainView()
        .modelContainer(for: Split.self, inMemory: true)
}
