import SwiftUI
import Combine

struct AuthorizeContentView: View {

    typealias Props = AuthorizeContentProps

    // MARK: - Private properties

    @ObservedObject private var props: Props

    // MARK: - Initialization

    init(props: Props) {
        self.props = props
    }

    // MARK: - Views

    var body: some View {
        VStack {
            Button {
                props.send(event: .finish)
            } label: {
                Text("Authorize")
            }
        }
    }
}
