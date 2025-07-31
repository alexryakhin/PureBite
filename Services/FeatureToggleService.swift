//
//  FeatureToggleServiceInterface.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import Foundation
import Combine

enum FeatureToggle: String, CaseIterable {

    case mock_data
    case print_json_responses

    var isEnabledByDefault: Bool {
        switch self {
        case .mock_data: true
        case .print_json_responses: false
        }
    }

    var title: String {
        switch self {
        case .mock_data: "Use mock data if available for requests."
        case .print_json_responses: "Print JSON responses."
        }
    }
}

typealias FeatureToggles = [FeatureToggle: Bool]

@MainActor
final class FeatureToggleService: ObservableObject {
    static let shared = FeatureToggleService()
    
    @Published private(set) var featureToggles = CurrentValueSubject<FeatureToggles, Never>([:])
    
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

extension FeatureToggles {
    func isEnabled(_ feature: FeatureToggle) -> Bool {
        self[feature] == true
    }
}
