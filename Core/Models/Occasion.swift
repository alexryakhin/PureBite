//
//  Occasion.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

enum Occasion: String, Codable, Hashable, CaseIterable {
    case spring = "spring"
    case summer = "summer"
    case fall = "fall"
    case winter = "winter"
    case other = "other"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Occasion(rawValue: rawValue.lowercased()) ?? .other
    }
}

extension Array where Element == Occasion {
    var toData: Data {
        guard let data = try? JSONEncoder().encode(self) else {
            return Data()
        }
        return data
    }
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

extension Data {
    var toOccasions: [Occasion] {
        guard let occasions = try? JSONDecoder().decode([Occasion].self, from: self) else {
            return []
        }
        return occasions
    }
}
