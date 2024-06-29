import SwiftUI
import Combine

struct ShoppingListContentView: ViewWithBackground {

    typealias Props = ShoppingListContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var content: some View {
        Text("ShoppingList")
    }
}
