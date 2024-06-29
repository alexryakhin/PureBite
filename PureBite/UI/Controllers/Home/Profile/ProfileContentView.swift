import SwiftUI
import Combine

struct ProfileContentView: ViewWithBackground {

    typealias Props = ProfileContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var content: some View {
        Text("Profile")
    }
}
