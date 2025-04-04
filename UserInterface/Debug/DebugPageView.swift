import SwiftUI
import Combine
import Core
import CoreUserInterface
import Shared

public struct DebugPageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: DebugPageViewModel

    // MARK: - Initialization

    public init(viewModel: DebugPageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        List {
            Section {
                ForEach(Array(viewModel.featureToggles), id: \.key) { toggle in
                    Toggle(isOn: Binding(
                        get: { toggle.value },
                        set: { _ in viewModel.handle(.toggleFeature(feature: toggle.key)) })) {
                        Text(toggle.key.title)
                    }
                }
            } header: {
                Text("Feature toggles")
            }
        }
    }
}
