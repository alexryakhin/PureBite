//
//  Occasion.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

public enum Occasion: String, Codable, Hashable, CaseIterable {
    case spring = "spring"
    case summer = "summer"
    case fall = "fall"
    case winter = "winter"
    case other = "other"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Occasion(rawValue: rawValue.lowercased()) ?? .other
    }
}

public extension Array where Element == Occasion {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}

public extension String {
    var toOccasions: [Occasion] {
        self.components(separatedBy: ",").compactMap({ Occasion(rawValue: $0) })
    }
}
