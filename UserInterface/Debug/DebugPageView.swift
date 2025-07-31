import SwiftUI
import Combine

public struct DebugPageView: View {

    // MARK: - Private properties

    @ObservedObject public var viewModel: DebugViewModel

    // MARK: - Initialization

    public init(viewModel: DebugViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
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
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }
}
