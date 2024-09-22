import UIKit

public final class SnackView: RSView, ConfigurableView {

    // MARK: - Types

    enum Constant {
        static let autohide: Bool = true
        static let appearDuration: TimeInterval = 0.2
        static let showDuration: TimeInterval = 3
    }

    enum Event {
        static let rootWillDisappear: String = "Snack.rootWillDisappear"
    }

    public struct Config: Equatable {

        public enum SnackStyle: Equatable {
            case basic
            case error
        }

        public let message: String
        public let style: SnackStyle

        public init(message: String, style: SnackStyle = .basic) {
            self.message = message
            self.style = style
        }

        public static func == (lhs: Config, rhs: Config) -> Bool {
            return lhs.message == rhs.message
        }
    }

    // MARK: - Public Properties

    var onDismiss: VoidHandler?
    var config: Config!

    // MARK: - Private Properties

    private var autohide: Bool = Constant.autohide
    private var showDuration: TimeInterval = Constant.showDuration

    private let titleLabel = KLabel()
        .fontStyle(.body)
        .foregroundStyle(.primary)
        .multiline()
        .textAlignment(.left)

    private lazy var contentView = body()

    // MARK: - Lifecycle

    override public func willMove(toSuperview newSuperview: UIView?) {
        defer { super.willMove(toSuperview: newSuperview) }
        guard newSuperview != nil else { return }

        alpha = 0
        fadeIn()

        if autohide {
            startTimer()
        }
    }

    // MARK: - Public Methods

    override public func setup() {
        super.setup()

        body().embed(in: self)
        setupSwipeToCloseGesture()
        setupCloseEvent()

        cornerRadius(24)
        backgroundStyle(.backgroundPrimary)
        clipsToBounds(false)
    }

    public func configure(with model: Config) {
        titleLabel.text(model.message)
        backgroundStyle(.surfacePrimary)
    }

    public func setAutohide(_ autohide: Bool) {
        self.autohide = autohide
    }

    public func setShowTime(_ showDuration: TimeInterval) {
        self.showDuration = showDuration
    }

    // MARK: - Private Methods

    private func body() -> BaseView {
        BaseBackgroundView(vPadding: 14, hPadding: 24) {
            titleLabel
        }
    }

    private func setupSwipeToCloseGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(dismiss)
        )
        swipeGestureRecognizer.direction = .up
        addGestureRecognizer(swipeGestureRecognizer)
    }

    private func setupCloseEvent() {
        let closeEventName = NSNotification.Name(rawValue: Event.rootWillDisappear)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismiss),
            name: closeEventName,
            object: nil
        )
    }

    @objc private func startTimer() {
        Timer.scheduledTimer(
            timeInterval: showDuration,
            target: self,
            selector: #selector(dismiss),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func dismiss() {
        fadeOut { [weak self] in
            self?.onDismiss?()
            self?.removeFromSuperview()
        }
    }
}
