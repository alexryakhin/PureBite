import UIKit

open class BaseActivityIndicatorView: UIActivityIndicatorView, StartStoppable {

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setup()
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods to Implement

    open func setup() { }

    // MARK: - Public Methods

    open func start(completion: (() -> ())?) {
        startAnimating()
        completion?()
    }

    open func stop(completion: (() -> ())?) {
        stopAnimating()
        completion?()
    }

}
