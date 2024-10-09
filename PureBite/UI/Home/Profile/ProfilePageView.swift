import SwiftUI
import Combine

public struct ProfilePageView: PageView {

    // MARK: - Private properties

    @ObservedObject public var viewModel: ProfilePageViewModel

    // MARK: - Initialization

    public init(viewModel: ProfilePageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    public var contentView: some View {
        Text("Profile")
    }
}