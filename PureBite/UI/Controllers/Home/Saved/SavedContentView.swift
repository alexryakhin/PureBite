import SwiftUI
import Combine

struct SavedContentView: ViewWithBackground {

    typealias Props = SavedContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var content: some View {
        Text("Saved")
    }
}
