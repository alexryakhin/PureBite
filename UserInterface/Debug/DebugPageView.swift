import SwiftUI
import Combine

struct DebugPageView: View {

    // MARK: - Private properties

    @StateObject private var viewModel = DebugViewModel()

    // MARK: - Body

    var body: some View {
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
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }
}
