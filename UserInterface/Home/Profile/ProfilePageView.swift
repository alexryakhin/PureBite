import SwiftUI
import Combine

struct ProfilePageView: View {

    // MARK: - Private properties

    @ObservedObject var viewModel: ProfilePageViewModel


    init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
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
