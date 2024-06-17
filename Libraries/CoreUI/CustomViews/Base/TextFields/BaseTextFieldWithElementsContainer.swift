import UIKit

/// Wrapper around of any text field.
/// Contains title, trailing accessory and supporting text.
/// Notifies about field events such as edit and clear.
/// Have state and can handle it's changes
open class BaseTextFieldWithElementsContainer<TextField: UITextField, TitleLabel: UILabel, SupportingLabel: UILabel>: BaseTextFieldContainer<TextField> {

    // MARK: - Properties

    /// Label above text field
    public var titleLabel: TitleLabel {
        if let titleLabel = _titleLabel {
            return titleLabel
        } else {
            let titleLabel = Self.makeTitleLabel()
            _titleLabel = titleLabel
            return titleLabel
        }
    }
    /// Label below text field
    public var supportingTextLabel: SupportingLabel {
        if let supportingTextLabel = _supportingTextLabel {
            return supportingTextLabel
        } else {
            let supportingTextLabel = Self.makeSupportingLabel()
            _supportingTextLabel = supportingTextLabel
            return supportingTextLabel
        }
    }

    public lazy var trailingAccessoryContainer = KHStack()

    // MARK: - Private Properties

    private var _titleLabel: TitleLabel?
    private var _supportingTextLabel: SupportingLabel?

    private var supportingTextBeforeError: String?

    // MARK: - Init

    public init(
        title: String? = nil,
        text: String? = nil,
        placeholder: String? = nil,
        supportingText: String? = nil
    ) {
        super.init(frame: .zero)
        titleLabel.text(title)
        set(text: text)
        textField.placeholder(placeholder)
        supportingTextLabel.text(supportingText)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override open func layout() {
        let content = KVStack {
            titleLabel
            KHStack(alignment: .center) {
                textField
                trailingAccessoryContainer.isHidden(true)
            }
            supportingTextLabel
        }
        embed(subview: content)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        trailingAccessoryContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    open func set(trailingAccessoryView: UIView, leadingPadding: CGFloat, trailingPadding: CGFloat) {
        trailingAccessoryContainer.set(arrangedSubviews: [
            BaseSpacer(length: leadingPadding),
            trailingAccessoryView,
            BaseSpacer(length: trailingPadding)
        ])
        trailingAccessoryContainer.isHidden = false
    }

    open func removeTrailingAccessoryView() {
        trailingAccessoryContainer.removeArrangedSubviews()
        trailingAccessoryContainer.isHidden = true
    }

    // MARK: - Public Methods to Implement

    open class func makeTitleLabel() -> TitleLabel { TitleLabel() }
    open class func makeSupportingLabel() -> SupportingLabel { SupportingLabel() }

    override open func resetState() {
        if isError {
            supportingTextLabel.text = supportingTextBeforeError
            supportingTextBeforeError = nil
        }
        super.resetState()
    }

    override open func setError(message: String?, enableIfDisabled: Bool = true) {
        if message != nil {
            if !isError {
                supportingTextBeforeError = supportingTextLabel.text
            }
            supportingTextLabel.text = message
        }
        super.setError(message: message, enableIfDisabled: enableIfDisabled)
    }
}
