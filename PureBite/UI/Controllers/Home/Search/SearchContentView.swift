import SwiftUI
import Combine

struct SearchContentView: ViewWithBackground {

    typealias Props = SearchContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var content: some View {
        Text("Search")
    }
}
