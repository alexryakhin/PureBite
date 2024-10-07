//
//  Review.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct Review: Codable, Identifiable {
    public let id: Int
    public let user: String
    public let rating: Int
    public let comment: String
    public let date: Date
}
