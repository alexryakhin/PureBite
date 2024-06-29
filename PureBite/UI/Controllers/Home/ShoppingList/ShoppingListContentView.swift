import AppIndependent
import SwiftUI
import Core
import Combine

struct ShoppingListContentView: View {

    typealias Props = ShoppingListContentProps

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
