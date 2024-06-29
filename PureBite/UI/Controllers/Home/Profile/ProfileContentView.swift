import AppIndependent
import SwiftUI
import Core
import Combine

struct ProfileContentView: View {

    typealias Props = ProfileContentProps

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
