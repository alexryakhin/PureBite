import SwiftUI

public struct PageSuccessViewConfig {
    public let title: String
    public let message: String
    public let image: Image

    public init(title: String, message: String, image: Image = Image(systemName: "checkmark")) {
        self.title = title
        self.message = message
        self.image = image
    }
}

struct PageSuccessView: View {

    private let config: PageSuccessViewConfig
    private let action: () -> Void

    init(config: PageSuccessViewConfig, action: @escaping () -> Void) {
        self.config = config
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()
            config.image
                .padding(.bottom, 24)
            VStack(spacing: 16) {
                Text(config.title)
                    .textStyle(.title1)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                Text(config.message)
                    .textStyle(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            StyledButton(stretchedText: "Thanks", style: .primary) {
                action()
            }
        }
        .padding(16)
    }
}
