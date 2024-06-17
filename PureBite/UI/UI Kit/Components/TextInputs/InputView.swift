import SwiftUI

struct InputView: View {

    @Binding private var text: String
    @Binding private var state: BasicInputView.State

    private let placeholder: String
    private let header: String?
    private let caption: String?
    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let shouldChangeRule: ((String, NSRange, String) -> Bool)?
    private let overrideBackgroundColor: UIColor?

    init(
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        placeholder: String,
        header: String? = nil,
        caption: String? = nil,
        textAlignment: NSTextAlignment = .left,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        shouldChangeRule: ((String, NSRange, String) -> Bool)? = nil,
        overrideBackgroundColor: UIColor? = nil
    ) {
        self._text = text
        self._state = state
        self.placeholder = placeholder
        self.header = header
        self.caption = caption
        self.textAlignment = textAlignment
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.shouldChangeRule = shouldChangeRule
        self.overrideBackgroundColor = overrideBackgroundColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let header {
                Text(header)
                    .textStyle(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
            }
            HStack {
                BasicInputView(
                    text: $text,
                    state: $state,
                    isSecureTextEntry: .constant(false),
                    placeholder: placeholder,
                    textAlignment: textAlignment,
                    keyboardType: keyboardType,
                    autocorrectionType: .no,
                    autocapitalizationType: .none,
                    spellCheckingType: .no,
                    textContentType: textContentType,
                    shouldChangeRule: shouldChangeRule ?? { _, _, _ in return true }
                )
                .frame(height: 18)
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .background(state != .error ? overrideBackgroundColor?.swiftUIColor ?? state.backgroundColor.swiftUIColor : state.backgroundColor.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            if let caption {
                Text(caption)
                    .textStyle(.caption1)
                    .foregroundColor(state == .error ? .red : .secondary)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 12)
    }
}
