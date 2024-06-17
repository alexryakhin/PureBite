import Foundation
import SwiftUI

public struct BasicTextView: UIViewRepresentable {

    @Binding private var text: String
    @Binding private var state: BasicInputView.State
    @Binding private var isSecureTextEntry: Bool

    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let autocorrectionType: UITextAutocorrectionType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let spellCheckingType: UITextSpellCheckingType
    private let textContentType: UITextContentType?
    private let shouldChangeRule: ((String, NSRange, String) -> Bool)

    public init(
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        isSecureTextEntry: Binding<Bool> = .constant(false),
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
        self.textAlignment = textAlignment
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.spellCheckingType = spellCheckingType
        self.textContentType = textContentType
        self.shouldChangeRule = shouldChangeRule
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textColor = .label
        textView.font = KTextStyle.body.font
        textView.keyboardType = keyboardType
        textView.autocorrectionType = autocorrectionType
        textView.autocapitalizationType = autocapitalizationType
        textView.spellCheckingType = spellCheckingType
        textView.returnKeyType = .done
        textView.textAlignment = textAlignment
        textView.delegate = context.coordinator
        textView.textContentType = textContentType
        textView.setSecureTextEntry(to: isSecureTextEntry)
        textView.contentInsets(top: 8, bottom: 8)
        return textView
    }

    public func makeCoordinator() -> BasicTextView.Coordinator {
        return Coordinator(text: $text, state: $state, shouldChangeRule: shouldChangeRule)
    }

    public func updateUIView(_ textView: UITextView, context: Context) {
        if textView.text != text {
            textView.text = text
        }
        textView.setSecureTextEntry(to: isSecureTextEntry)
        textView.backgroundColor = state.backgroundColor
    }

    public final class Coordinator: NSObject, UITextViewDelegate {
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

        public func textViewDidChangeSelection(_ textView: UITextView) {
            text = textView.text ?? ""
        }

        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }

            return shouldChangeRule(self.text, range, text)
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            if state != .error { state = .focused }
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            if state != .error { state = .pending }
        }
    }
}

// Remove side effect on toggling, which causes removal of symbols
extension UITextView {
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
