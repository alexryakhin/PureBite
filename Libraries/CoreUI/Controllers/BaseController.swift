import UIKit
import Combine

open class BaseController: UIViewController {

    // MARK: - Public Properties

    open var onBack: (() -> Void)?
    public var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            onBack?()
        }
    }

    // MARK: - Public Methods

    open func setup() {}

    deinit {
        CoreUIManager.logger.logDeinit(self)
    }
}
