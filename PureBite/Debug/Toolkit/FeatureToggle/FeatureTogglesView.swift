#if DEBUG

import SwiftUI

struct FeatureTogglesView: View {

    @State private var featureToggles: FeatureToggles
    private let featureToggleService: FeatureToggleServiceInterface

    init(featureToggleService: FeatureToggleServiceInterface) {
        self.featureToggleService = featureToggleService
        _featureToggles = State(initialValue: featureToggleService.featureToggles.value)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(FeatureToggle.allCases, id: \.self) { feature in
                    Toggle(isOn: Binding(
                        get: { featureToggles.isEnabled(feature) },
                        set: { featureToggles[feature] = $0 }
                    )) {
                        Text(feature.title)
                    }
                }
            }
            .navigationTitle("Feature Toggles")
            .onChange(of: featureToggles) {
                featureToggleService.featureToggles.send($0)
            }
        }
    }
}

#endif
