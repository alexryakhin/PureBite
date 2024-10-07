//
//  InputState.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//
import UIKit
import SwiftUI

public enum InputState: Equatable {
    case pending
    case error
    case focused

    public var rawValue: Int {
        switch self {
        case .pending: return 0
        case .error: return 1
        case .focused: return 2
        }
    }

    public var backgroundColor: Color {
        switch self {
        case .pending, .focused: .secondarySystemBackground
        case .error: .red
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
