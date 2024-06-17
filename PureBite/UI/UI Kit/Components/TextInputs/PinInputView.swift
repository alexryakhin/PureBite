import SwiftUI

struct PinInputView: View {
    @Binding private var text: String
    @Binding private var state: BasicInputView.State
    @Binding private var caption: String?

    private let pinLength: Int
    private let placeholder: String
    private let header: String?
    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let shouldChangeRule: ((String, String) -> Bool)?

    init(
        pinLength: Int,
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        placeholder: String,
        header: String? = nil,
        caption: Binding<String?> = .constant(nil),
        textAlignment: NSTextAlignment = .left,
        keyboardType: UIKeyboardType = .numberPad,
        textContentType: UITextContentType? = nil,
        shouldChangeRule: ((String, String) -> Bool)? = nil
    ) {
        self._text = text
        self._state = state
        self._caption = caption
        self.pinLength = pinLength
        self.placeholder = placeholder
        self.header = header
        self.textAlignment = textAlignment
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.shouldChangeRule = shouldChangeRule
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let header {
                Text(header)
                    .textStyle(.subheadline)
                    .foregroundColor(.secondary)
            }
            HStack {
                BasicPinInputView(
                    pinLength: pinLength,
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
                    shouldChangeRule: shouldChangeRule ?? { _, _ in return true }
                )
                .frame(height: 18)
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .background(state.backgroundColor.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            if let caption {
                Text(caption)
                    .textStyle(.caption1)
                    .foregroundColor(state == .error ? .red : .secondary)
            }
        }
    }
}
