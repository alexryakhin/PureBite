import SwiftUI

public struct PageErrorView: ViewWithBackground {

    typealias Props = DefaultErrorProps

    private let props: Props

    public init(props: DefaultErrorProps) {
        self.props = props
    }

    public var content: some View {
        VStack {
            Spacer()
            errorView
            Spacer()
            StyledButton(
                stretchedText: props.actionProps.title,
                style: .primary(),
                onTap: props.actionProps.action
            )
        }
        .padding(16)
    }

    private var errorView: some View {
        VStack(spacing: 4) {
            Text(props.title)
                .fontStyle(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
            Text(props.message)
                .fontStyle(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
