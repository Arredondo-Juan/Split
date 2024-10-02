//
//  ContentView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct MainView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.customPurple]
    }
    
    @State private var selectedTab: String = "All"
    @State private var activeSegment: String = "Active"
    @State private var isCreateSplitPresented: Bool = false
    @State private var splits: [Split] = []
    
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
                
                if splits.isEmpty {
                    Spacer()
                    
                    VStack {
                        Image("iconsReceipt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .padding()
                        Text("No Splits created yet")
                            .font(.headline)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(splits) { split in
                                SplitItemView(split: split)
                            }
                        }
                        .padding()
                    }
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
            .navigationDestination(isPresented: $isCreateSplitPresented) {
                CreateNewSplitView(splits: $splits)
            }
        }
    }
}

#Preview {
    MainView()
}
