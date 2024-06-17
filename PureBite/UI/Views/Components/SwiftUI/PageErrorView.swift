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
                    .frame(width: 240, height: 240)
            }
            VStack(spacing: 4) {
                Text(props.title)
                    .textStyle(.title2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                Text(props.message)
                    .textStyle(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
