import SwiftUI

struct SearchInputView: View {

    enum Style {
        case regular
    }

    @Binding private var text: String
    @Binding private var state: BasicInputView.State

    private let style: Style
    private let placeholder: String
    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?

    init(
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        style: Style = .regular,
        placeholder: String = "Search",
        textAlignment: NSTextAlignment = .left,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        self._text = text
        self._state = state
        self.style = style
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(style.foregroundColor.swiftUIColor)

            BasicInputView(
                text: $text,
                state: $state,
                isSecureTextEntry: .constant(false),
                textColor: style.textColor,
                placeholder: placeholder,
                placeholderColor: style.placeholderColor,
                textAlignment: textAlignment,
                keyboardType: keyboardType,
                autocorrectionType: .no,
                autocapitalizationType: .none,
                spellCheckingType: .no,
                textContentType: textContentType,
                shouldChangeRule: { _, _, _ in return true }
            )
            .frame(height: 18)

            if text.isNotEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(style.foregroundColor.swiftUIColor)
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(style.backgroundColor.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
    }
}

extension SearchInputView.Style {
    var cornerRadius: CGFloat {
        switch self {
        case .regular: 20
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .regular: .systemBackground
        }
    }

    var foregroundColor: UIColor {
        switch self {
        case .regular: .secondaryLabel
        }
    }

    var textColor: UIColor {
        switch self {
        case .regular: .label
        }
    }

    var placeholderColor: UIColor {
        switch self {
        case .regular: .secondaryLabel
        }
    }
}

#Preview {
    SearchInputView(text: .constant("Search text"), placeholder: "Search something")
}
