import SwiftUI

public struct BasicPinInputView: UIViewRepresentable {

    @Binding private var text: String
    @Binding private var state: BasicInputView.State
    @Binding private var isSecureTextEntry: Bool

    private let pinLength: Int
    private let placeholder: String
    private let textAlignment: NSTextAlignment
    private let keyboardType: UIKeyboardType
    private let autocorrectionType: UITextAutocorrectionType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let spellCheckingType: UITextSpellCheckingType
    private let textContentType: UITextContentType?
    private let shouldChangeRule: ((String, String) -> Bool)

    public init(
        pinLength: Int,
        text: Binding<String>,
        state: Binding<BasicInputView.State> = .constant(.pending),
        isSecureTextEntry: Binding<Bool> = .constant(false),
        placeholder: String = "",
        textAlignment: NSTextAlignment = .left,
        keyboardType: UIKeyboardType = .default,
        autocorrectionType: UITextAutocorrectionType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        spellCheckingType: UITextSpellCheckingType = .default,
        textContentType: UITextContentType? = nil,
        shouldChangeRule: @escaping ((String, String) -> Bool)
    ) {
        self._text = text
        self._state = state
        self._isSecureTextEntry = isSecureTextEntry
        self.pinLength = pinLength
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.spellCheckingType = spellCheckingType
        self.textContentType = textContentType
        self.shouldChangeRule = shouldChangeRule
    }

    public func makeUIView(context: UIViewRepresentableContext<BasicPinInputView>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.secondaryLabel]
        )
        textField.textColor = .label
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
        return textField
    }

    public func makeCoordinator() -> BasicPinInputView.Coordinator {
        return Coordinator(pinLength: pinLength, text: $text, state: $state, shouldChangeRule: shouldChangeRule)
    }

    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<BasicPinInputView>) {
        uiView.text = text
        uiView.setSecureTextEntry(to: isSecureTextEntry)
    }

    public final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var state: BasicInputView.State

        let pinLength: Int
        let shouldChangeRule: ((String, String) -> Bool)

        init(
            pinLength: Int,
            text: Binding<String>,
            state: Binding<BasicInputView.State>,
            shouldChangeRule: @escaping ((String, String) -> Bool)
        ) {
            _text = text
            _state = state
            self.pinLength = pinLength
            self.shouldChangeRule = shouldChangeRule
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let text = textField.text else {
                self.text = textField.text ?? ""
                return
            }

            var neededText = text
            while neededText.count < 4 {
                neededText += "•"
            }

            while neededText.count > 4 {
                neededText.removeLast()
            }

            textField.text = neededText
            self.text = textField.text ?? ""

            DispatchQueue.main.async {
                let index = self.text.filter({ $0.isNumber }).count
                let position = textField.position(from: textField.beginningOfDocument, offset: index) ?? textField.endOfDocument
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            }
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return shouldChangeRule(text, string)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            if state != .error { state = .pending }
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
}
