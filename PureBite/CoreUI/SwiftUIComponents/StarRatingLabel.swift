//
//  StarRatingLabel.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import SwiftUI

public struct StarRatingLabel: View {
    private let score: Double

    public init(score: Int) {
        self.score = Double(score)
    }

    public init(score: Double) {
        self.score = score
    }

    public var rating: Double {
        return (score / 100.0) * 5.0
    }

    public var body: some View {
        Label(
            title: {
                Text(String(format: "%.1f", rating))
            },
            icon: {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        )
    }
}
