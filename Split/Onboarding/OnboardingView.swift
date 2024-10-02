//
//  OnboardingView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var selectedViewIndex = 0
    @AppStorage("onboarding") var needsOnboarding = true
    
    let totalPages = 3  // Total number of onboarding pages
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedViewIndex) {
                
                OnboardingDetailsView(imageName: "iconsCompoundInterests", headlineText: "Main text goes here", subheadlineText: "Helper goes here") {
                    withAnimation {
                        selectedViewIndex = 1
                    }
                } skipAction: {
                    dismissOnboarding()
                }
                .tag(0)
                
                OnboardingDetailsView(imageName: "iconsReceipt2", headlineText: "Main text also goes here", subheadlineText: "Helper also goes here") {
                    withAnimation {
                        selectedViewIndex = 2
                    }
                } skipAction: {
                    dismissOnboarding()
                }
                .tag(1)
                
                OnboardingDetailsView(imageName: "iconsReceipt3", headlineText: "Main text goes here as well", subheadlineText: "Helper goes here as well") {
                    withAnimation {
                        dismissOnboarding()
                    }
                } skipAction: {
                    dismissOnboarding()
                }
                .tag(2)
            }
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Page Indicators
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(selectedViewIndex == index ? .customPurple : .customPalePurple)
                    }
                }
                .padding(.bottom, 90)
            }
        }
    }
    
    func dismissOnboarding() {
        dismiss()
        needsOnboarding = false
    }
}

#Preview {
    OnboardingView()
}
