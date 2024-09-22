//
//  NoResultsView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/24/24.
//

import SwiftUI

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Sad face icon (you can replace it with any image or SF Symbol)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.secondary)

            // Main "No Results Found" Text
            Text("No Results Found")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            // Additional Instructional Text
            Text("We couldn't find any recipes that match your search.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Suggestion to try again
            Text("Try using different keywords or adjusting your filters.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(16)
    }
}

#Preview {
    NoResultsView()
}
