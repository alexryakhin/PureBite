//
//  Cuisine.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

enum Cuisine: String, Codable, Hashable, CaseIterable {
    case african = "african"
    case asian = "asian"
    case american = "american"
    case british = "british"
    case cajun = "cajun"
    case caribbean = "caribbean"
    case chinese = "chinese"
    case easternEuropean = "eastern european"
    case european = "european"
    case french = "french"
    case german = "german"
    case greek = "greek"
    case indian = "indian"
    case irish = "irish"
    case italian = "italian"
    case japanese = "japanese"
    case jewish = "jewish"
    case korean = "korean"
    case latinAmerican = "latin american"
    case mediterranean = "mediterranean"
    case mexican = "mexican"
    case middleEastern = "middle eastern"
    case nordic = "nordic"
    case southern = "southern"
    case spanish = "spanish"
    case thai = "thai"
    case vietnamese = "vietnamese"
    case creole = "creole"
    case other = "other"

    var name: String {
        switch self {
        case .african: "African"
        case .asian: "Asian"
        case .american: "American"
        case .british: "British"
        case .cajun: "Cajun"
        case .caribbean: "Caribbean"
        case .chinese: "Chinese"
        case .easternEuropean: "Eastern European"
        case .european: "European"
        case .french: "French"
        case .german: "German"
        case .greek: "Greek"
        case .indian: "Indian"
        case .irish: "Irish"
        case .italian: "Italian"
        case .japanese: "Japanese"
        case .jewish: "Jewish"
        case .korean: "Korean"
        case .latinAmerican: "Latin American"
        case .mediterranean: "Mediterranean"
        case .mexican: "Mexican"
        case .middleEastern: "Middle Eastern"
        case .nordic: "Nordic"
        case .southern: "Southern"
        case .spanish: "Spanish"
        case .thai: "Thai"
        case .vietnamese: "Vietnamese"
        case .creole: "Creole"
        case .other: "Other"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Cuisine(rawValue: rawValue.lowercased()) ?? .other
    }
}

extension Array where Element == Cuisine {
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
    var toCuisines: [Cuisine] {
        guard let cuisines = try? JSONDecoder().decode([Cuisine].self, from: self) else {
            return []
        }
        return cuisines
    }
}
