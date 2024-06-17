import SwiftUI
import Combine

struct RecipeDetailsContentView: View {

    typealias Props = RecipeDetailsContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var body: some View {
        EmptyView()
    }
}
