//
//  SplitApp.swift
//  Split
//
//  Created by Juan Arredondo on 10/1/24.
//

import SwiftUI
import SwiftData

@main
struct SplitApp: App {
    @AppStorage("onboarding") var needsOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if needsOnboarding {
                    OnboardingView()
                } else {
                    MainView()
                }
            }
        }
        .modelContainer(for: Split.self)
    }
}
