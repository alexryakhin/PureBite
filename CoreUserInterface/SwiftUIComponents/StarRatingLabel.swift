//
//  StarRatingLabel.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import SwiftUI

struct StarRatingLabel: View {
    private let score: Double

    init(score: Int) {
        self.score = Double(score)
    }

    init(score: Double) {
        self.score = score
    }

    var rating: Double {
        return (score / 100.0) * 5.0
    }

    var body: some View {
        Label(
            title: {
                Text(String(format: "%.1f", rating))
            },
            icon: {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        )
    }
}
