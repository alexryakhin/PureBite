import SwiftUI

struct PageErrorView: View {

    typealias Props = DefaultErrorProps

    private let props: Props

    init(props: DefaultErrorProps) {
        self.props = props
    }

    var body: some View {
        VStack {
            Spacer()
            errorView
            Spacer()
            if let actionProps = props.actionProps {
                StyledButton(
                    stretchedText: actionProps.title,
                    style: .primary,
                    onTap: actionProps.action
                )
            }
        }
        .padding(16)
    }

    var errorView: some View {
        VStack(spacing: 16) {
            if let image = props.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 4) {
                Text(props.title)
                    .textStyle(.title2)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                Text(props.message)
                    .textStyle(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
