//
//  OnboardingDetailsView.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI

struct OnboardingDetailsView: View {
    
    var imageName: String
    var headlineText: String
    var subheadlineText: String
    var buttonAction: () -> Void
    var skipAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    skipAction()
                }) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                .padding(.trailing, 40)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(height: 200)  // Adjust height as needed
                .padding(.horizontal, 40)
            
            Text(headlineText)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(subheadlineText)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 8) // Space between headline and subheadline
            
            Spacer()
            
            Button {
                buttonAction()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.customPurple)
                        .frame(height: 50)
                    Text("Next")
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    OnboardingDetailsView(imageName: "iconsCompoundInterests", headlineText: "Test Headline", subheadlineText: "Test subheadline", buttonAction: {}, skipAction: {})
}
