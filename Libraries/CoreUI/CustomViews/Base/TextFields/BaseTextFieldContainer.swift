import Combine
import SnapKit
import UIKit

/// Wrapper around of any text field.
/// Notifies about field events such as edit and clear.
/// Have state and can handle it's changes
open class BaseTextFieldContainer<TextField: UITextField>: BaseView, UITextFieldDelegate {

    // MARK: - Types

    public enum InputAcceptBehavior {
        case acceptAll
        case acceptNone
    }

    // MARK: - Properties

    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.layoutFittingExpandedSize.width, height: UIView.noIntrinsicMetric)
    }

    public var textField: TextField {
        if let textField = _textField {
            return textField
        } else {
            let textField = Self.makeTextField()
            _textField = textField
            return textField
        }
    }

    public var resetStateOnFocus = true
    public var acceptBehavior: InputAcceptBehavior = .acceptAll
    public var fieldRestrictions: [FieldRestriction] = []

    @Published public private(set) var state: FieldState = .normal
    @Published public private(set) var isError: Bool = false
    @Published public private(set) var text: String?

    public var cancellables = Set<AnyCancellable>()

    // MARK: - Private Properties

    private var _textField: TextField?

    // MARK: - Public Methods

    override open func setup() {
        super.setup()
        layout()
        setupBindings()
    }

    open func layout() {
        embed(subview: textField)
    }

    open func setupBindings() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $state
            .combineLatest($isError)
            .subscribe(on: RunLoop.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateAppearance()
                }
            }.store(in: &cancellables)
    }

    open func focus() {
        textField.becomeFirstResponder()
    }

    open func set(text: String?) {
        textField.text = text
        self.text = text
    }

    // MARK: - State changes

    open func resetState() {
        if isError {
            isError = false
        }
        textField.isEnabled = true
    }

    @discardableResult
    open func disableIfEnabled() -> Self {
        guard state != .disabled else {
            return self
        }
        state = .disabled
        if isError {
            isError = false
        }
        textField.isEnabled = false
        return self
    }

    @discardableResult
    open func enableIfDisabled() -> Self {
        guard state == .disabled else {
            return self
        }
        textField.isEnabled = true
        return self
    }

    open func setError(message: String?, enableIfDisabled: Bool = true) {
        guard !isError else {
            return
        }
        if enableIfDisabled {
            textField.isEnabled = true
        }
        isError = true
    }

    // MARK: - Public Methods to Implement

    open class func makeTextField() -> TextField { TextField() }

    open func shouldReturn(text: String?) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    open func shouldAccept(string: String, resultText: String) -> Bool {
        switch acceptBehavior {
        case .acceptAll:
            for restriction in fieldRestrictions {
                switch restriction {
                case .maxLength(let maxLength):
                    // TODO: check voice input
                    if resultText.count > maxLength {
                        return false
                    }
                }
            }
            return true
        case .acceptNone:
            return false
        }
    }

    override open func updateAppearance() {
        super.updateAppearance()

        setupDefaultAppearance()

        if isError {
            setupErrorAppearance()
            return
        }

        switch state {
        case .normal:
            setupNormalAppearance()
        case .focused:
            setupFocusedAppearance()
        case .disabled:
            setupDisabledAppearance()
        }
    }

    open func setupDefaultAppearance() { }
    open func setupNormalAppearance() { }
    open func setupFocusedAppearance() { }
    open func setupDisabledAppearance() { }
    open func setupErrorAppearance() { }

    @discardableResult
    open func acceptBehavior(_ behavior: InputAcceptBehavior) -> Self {
        self.acceptBehavior = behavior
        return self
    }

    // MARK: - UITextFieldDelegate

    @objc open func textFieldDidChange(_ textField: UITextField) {
        if isError {
            resetState()
        }
        text = textField.text
    }

    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if resetStateOnFocus {
            state = .focused
        }
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        guard state != .disabled else { return }
        state = .normal
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        return shouldReturn(text: text)
    }

    open func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard
            let currentText = textField.text,
            let textRange = Range(range, in: currentText)
        else {
            return shouldAccept(string: string, resultText: string)
        }
        let resultText = currentText.replacingCharacters(in: textRange, with: string)
        return shouldAccept(string: string, resultText: resultText)
    }
}
