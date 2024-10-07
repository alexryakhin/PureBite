//
//  AppEnvironment.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

public enum AppEnvironment: Int, CaseIterable {
 #if DEBUG
    case debug
 #endif
    case release

    public var name: String {
        switch self {
 #if DEBUG
        case .debug:
            return "debug"
 #endif
        case .release:
            return "release"
        }
    }

    public static func named(_ name: String) -> AppEnvironment? {
        return Self.allCases.first(where: { $0.name == name })
    }
}
