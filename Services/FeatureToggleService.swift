//
//  FeatureToggleServiceInterface.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import Foundation
import Combine
import Core
import Shared

public enum FeatureToggle: String, CaseIterable {

    case mock_data
    case print_json_responses

    public var isEnabledByDefault: Bool {
        switch self {
        case .mock_data: true
        case .print_json_responses: false
        }
    }

    public var title: String {
        switch self {
        case .mock_data: "Use mock data if available for requests."
        case .print_json_responses: "Print JSON responses."
        }
    }
}

public typealias FeatureToggles = [FeatureToggle: Bool]

@MainActor
public final class FeatureToggleService: ObservableObject {
    public static let shared = FeatureToggleService()
    
    @Published public private(set) var featureToggles = CurrentValueSubject<FeatureToggles, Never>([:])
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setDefaults()
    }
    
    private func setDefaults() {
        let defaults = Dictionary(uniqueKeysWithValues: FeatureToggle.allCases.map({ toggle in
            (toggle.rawValue, NSNumber(booleanLiteral: toggle.isEnabledByDefault))
        }))
        setValues()
    }
    
    private func setValues() {
        var toggles = FeatureToggles()
        for toggle in FeatureToggle.allCases {
            toggles[toggle] = toggle.isEnabledByDefault
        }
        featureToggles.send(toggles)
    }
}

public extension FeatureToggles {
    func isEnabled(_ feature: FeatureToggle) -> Bool {
        self[feature] == true
    }
}
