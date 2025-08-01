//
//  WelcomeSheetView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI

struct WelcomeSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    private let pages = WelcomePage.allPages
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Page Content
                    TabView(selection: $currentPage) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                            WelcomePageView(page: page)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentPage)
                    
                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.accentColor : Color(.systemGray4))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                dismiss()
                            }
                        } label: {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        if currentPage < pages.count - 1 {
                            Button {
                                dismiss()
                            } label: {
                                Text("Skip")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            AnalyticsService.shared.trackScreen(.welcome)
        }
    }
}

struct WelcomePageView: View {
    let page: WelcomePage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.accentColor)
                .frame(height: 100)
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct WelcomePage {
    let icon: String
    let title: String
    let description: String
    
    static let allPages: [WelcomePage] = [
        WelcomePage(
            icon: "fork.knife",
            title: "Welcome to PureBite",
            description: "Your personal recipe companion. Discover, save, and cook delicious recipes with ease."
        ),
        WelcomePage(
            icon: "magnifyingglass",
            title: "Smart Recipe Discovery",
            description: "Find recipes by ingredients you have, search by name, or discover trending dishes from around the world."
        ),
        WelcomePage(
            icon: "heart.fill",
            title: "Save Your Favorites",
            description: "Build your personal cookbook. Save recipes you love and access them anytime, even offline."
        ),
        WelcomePage(
            icon: "cart.fill",
            title: "Smart Shopping List",
            description: "Add ingredients directly from recipes to your shopping list. Never forget an ingredient again."
        ),
        WelcomePage(
            icon: "lock.shield",
            title: "Privacy First",
            description: "Your data stays on your device. No personal information collected. You're in control."
        )
    ]
}

#Preview {
    WelcomeSheetView()
} 