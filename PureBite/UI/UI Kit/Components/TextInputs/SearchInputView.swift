import SwiftUI

struct SearchInputView: View {

    enum Style {
        case regular
    }

    @Binding private var text: String
    @Binding private var state: BasicInputView.State
    @Binding private var isFocused: Bool
    @FocusState private var focusState: Bool

    private let style: Style
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let onSubmit: (() -> Void)?

    init(
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        isFocused: Binding<Bool> = .constant(false),
        style: Style = .regular,
        placeholder: String = "Search",
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self._state = state
        self._isFocused = isFocused
        self.style = style
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.onSubmit = onSubmit
    }

    var body: some View {
        HStack(spacing: 0) {

            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.secondary)

                TextField(text: $text) {
                    Text(placeholder)
                }
                .submitLabel(.search)
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .focused($focusState, equals: true)
                .onSubmit {
                    onSubmit?()
                }
                .onChange(of: focusState) { newValue in
                    isFocused = focusState
                }

                if text.isNotEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(style.backgroundColor.swiftUIColor)
            .clipShape(Capsule())
            .shadow(radius: 2)

            if focusState {
                StyledButton(text: "Cancel", style: .textMini) {
                    // cancel
                    focusState = false
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.default)
    }
}

extension SearchInputView.Style {
    var backgroundColor: UIColor {
        switch self {
        case .regular: .surfaceBackground
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
    SearchInputView(text: .constant(.empty), placeholder: "Search something")
}
