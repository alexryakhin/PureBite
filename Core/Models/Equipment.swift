//
//  Equipment.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/23/24.
//

import Foundation

public enum Equipment: String, Codable {
    case pan = "pan"
    case fryingPan = "frying pan"
    case bowl = "bowl"
    case blender = "blender"
    case oven = "oven"
    case microwave = "microwave"
    case knife = "knife"
    case cuttingBoard = "cutting board"
    case spatula = "spatula"
    case whisk = "whisk"
    case grater = "grater"
    case pot = "pot"
    case saucepan = "saucepan"
    case bakingSheet = "baking sheet"
    case mixer = "mixer"
    case foodProcessor = "food processor"
    case measuringCup = "measuring cup"
    case measuringSpoon = "measuring spoon"
    case rollingPin = "rolling pin"
    case colander = "colander"
    case peeler = "peeler"
    case ladle = "ladle"
    case tongs = "tongs"
    case kitchenScale = "kitchen scale"
    case thermomether = "thermometer"
    case other = "other"

    var name: String {
        switch self {
        case .pan: "Pan"
        case .fryingPan: "Frying Pan"
        case .bowl: "Bowl"
        case .blender: "Blender"
        case .oven: "Oven"
        case .microwave: "Microwave"
        case .knife: "Knife"
        case .cuttingBoard: "Cutting Board"
        case .spatula: "Spatula"
        case .whisk: "Whisk"
        case .grater: "Grater"
        case .pot: "Pot"
        case .saucepan: "Saucepan"
        case .bakingSheet: "Baking Sheet"
        case .mixer: "Mixer"
        case .foodProcessor: "Food Processor"
        case .measuringCup: "Measuring Cup"
        case .measuringSpoon: "Measuring Spoon"
        case .rollingPin: "Rolling Pin"
        case .colander: "Colander"
        case .peeler: "Peeler"
        case .ladle: "Ladle"
        case .tongs: "Tongs"
        case .kitchenScale: "Kitchen Scale"
        case .thermomether: "Thermometer"
        case .other: "Other"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Equipment(rawValue: rawValue.lowercased()) ?? .other
    }
}

public extension Array where Element == Equipment {
    var toString: String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
}
