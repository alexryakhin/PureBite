//
//  SearchPlaceholderView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/24/24.
//
import SwiftUI

struct SearchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Placeholder Icon (you can use any image or SF Symbol)
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.secondary)

            // Placeholder Text
            Text("Start searching for recipes")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Additional Text or Instructions (Optional)
            Text("Try typing an ingredient or dish name to find new recipes.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
