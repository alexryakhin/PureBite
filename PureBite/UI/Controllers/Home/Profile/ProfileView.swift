import SwiftUI
import Combine

struct ProfileView: PageView {

    typealias ViewModel = ProfileViewModel

    // MARK: - Private properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var contentView: some View {
        Text("Profile")
    }
}
