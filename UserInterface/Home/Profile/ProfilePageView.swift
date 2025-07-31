import SwiftUI
import Combine

public struct ProfilePageView: View {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ProfilePageViewModel

    // MARK: - Initialization

    public init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        Text("Profile")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "An error occurred")
            }
    }
}
