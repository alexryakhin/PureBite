import SwiftUI

struct SearchInputView: View {

    enum Style {
        case regular
    }

    @Binding private var text: String
    @Binding private var state: BasicInputView.State

    private let style: Style
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?

    init(
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        style: Style = .regular,
        placeholder: String = "Search",
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        self._text = text
        self._state = state
        self.style = style
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }

    var body: some View {
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
    }
}

extension SearchInputView.Style {
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
    SearchInputView(text: .constant(.empty), placeholder: "Search something")
}
