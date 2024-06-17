import SwiftUI

public struct BasicInputView: UIViewRepresentable {

    @Binding private var text: String
    @Binding private var state: State
    @Binding private var isSecureTextEntry: Bool

    private let textColor: UIColor
    private let placeholder: String
    private let placeholderColor: UIColor
    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let autocorrectionType: UITextAutocorrectionType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let spellCheckingType: UITextSpellCheckingType
    private let textContentType: UITextContentType?
    private let shouldChangeRule: ((String, NSRange, String) -> Bool)

    public init(
        text: Binding<String>,
        state: Binding<State> = .constant(.pending),
        isSecureTextEntry: Binding<Bool> = .constant(false),
        textColor: UIColor = .label,
        placeholder: String = "",
        placeholderColor: UIColor = .secondaryLabel,
        textAlignment: NSTextAlignment = .left,
        keyboardType: UIKeyboardType = .default,
        autocorrectionType: UITextAutocorrectionType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        spellCheckingType: UITextSpellCheckingType = .default,
        textContentType: UITextContentType? = nil,
        shouldChangeRule: @escaping ((String, NSRange, String) -> Bool)
    ) {
        self._text = text
        self._state = state
        self._isSecureTextEntry = isSecureTextEntry
        self.keyboardType = keyboardType
        self.textColor = textColor
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.textAlignment = textAlignment
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.spellCheckingType = spellCheckingType
        self.textContentType = textContentType
        self.shouldChangeRule = shouldChangeRule
    }

    public func makeUIView(context: UIViewRepresentableContext<BasicInputView>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        textField.textColor = textColor
        textField.font = KTextStyle.body.font
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.spellCheckingType = spellCheckingType
        textField.returnKeyType = .done
        textField.textAlignment = textAlignment
        textField.delegate = context.coordinator
        textField.textContentType = textContentType
        textField.setSecureTextEntry(to: isSecureTextEntry)
        switch keyboardType {
        case .decimalPad, .asciiCapableNumberPad, .numberPad, .phonePad:
            setupToolbarWithDoneButton(for: textField)
        default:
            break
        }
        return textField
    }

    public func makeCoordinator() -> BasicInputView.Coordinator {
        return Coordinator(text: $text, state: $state, shouldChangeRule: shouldChangeRule)
    }

    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<BasicInputView>) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: placeholderColor])
        uiView.setSecureTextEntry(to: isSecureTextEntry)
    }

    public final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var state: BasicInputView.State

        let shouldChangeRule: ((String, NSRange, String) -> Bool)

        init(
            text: Binding<String>,
            state: Binding<BasicInputView.State>,
            shouldChangeRule: @escaping ((String, NSRange, String) -> Bool)
        ) {
            _text = text
            _state = state
            self.shouldChangeRule = shouldChangeRule
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return shouldChangeRule(text, range, string)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            if state != .error { state = .focused }
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            if text.isEmpty {
                // for unfocusing error check
                text = ""
            }
            if state != .error { state = .pending }
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if state != .error { state = .pending }
            return true
        }
    }

    func setupToolbarWithDoneButton(for textField: UITextField) {
        // Create a toolbar
        let toolbar = UIToolbar()
        // Create a done button with an action to trigger our function to dismiss the keyboard
        let doneAction = UIAction(title: "Done", handler: { _ in
            textField.endEditing(true)
        })
        let doneButton = UIBarButtonItem(title: "Done", primaryAction: doneAction)
        // Create a flexible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Add the created button items in the toolbar
        toolbar.items = [flexSpace, flexSpace, doneButton]
        toolbar.sizeToFit()
        // Add the toolbar to our textfield
        textField.inputAccessoryView = toolbar
    }
}

public extension BasicInputView {
    enum State: Equatable {
        case pending
        case error
        case focused

        var rawValue: Int {
            switch self {
            case .pending: return 0
            case .error: return 1
            case .focused: return 2
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .pending, .focused: .secondarySystemBackground
            case .error: .red
            }
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
    }
}

// Remove side effect on toggling, which causes removal of symbols
extension UITextField {
    func setSecureTextEntry(to isSecure: Bool) {
        if isSecureTextEntry == isSecure {
            return
        }
        isSecureTextEntry = isSecure

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
