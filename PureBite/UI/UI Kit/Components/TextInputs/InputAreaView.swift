import SwiftUI

struct InputAreaView: View {

    @Binding private var text: String
    @Binding private var state: BasicInputView.State

    private let placeholder: String
    private let header: String?
    private let caption: String?
    private let maxLength: Int?
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
        maxLength: Int? = nil,
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
        self.maxLength = maxLength
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

            BasicTextView(
                text: $text,
                state: $state,
                isSecureTextEntry: .constant(false),
                textAlignment: textAlignment,
                keyboardType: keyboardType,
                autocorrectionType: .no,
                autocapitalizationType: .none,
                spellCheckingType: .no,
                textContentType: textContentType,
                shouldChangeRule: shouldChangeRule ?? { text, range, string in
                    guard let maxLength else { return true }
                    let newString = (text as NSString).replacingCharacters(in: range, with: string)
                    return newString.count <= maxLength
                }
            )
            .padding(.horizontal, 8)
            .frame(height: 86)
            .background(state.backgroundColor.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .textStyle(.body)
                        .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .allowsHitTesting(false)
                }
            }

            HStack(alignment: .top, spacing: 4) {
                if let caption {
                    Text(caption)
                        .textStyle(.caption1)
                        .foregroundColor(state == .error ? .red : .secondary)
                }
                Spacer()
                if let maxLength {
                    Text("\(text.count) / \(maxLength)")
                        .textStyle(.caption1)
                        .foregroundColor(state == .error ? .red : .secondary)
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
    }
}
