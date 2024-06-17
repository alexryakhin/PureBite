import UIKit

// swiftlint:disable:next final_class
class Spinner: BaseView, StartStoppable {

    // MARK: - Properties

    private let spinnerProps: BaseSpinner.Props

    private lazy var spinner = BaseSpinner(props: spinnerProps)

    override var intrinsicContentSize: CGSize { spinnerProps.size }

    init(spinnerProps: BaseSpinner.Props) {
        self.spinnerProps = spinnerProps
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        embed(subview: spinner)
    }

    func start(completion: (() -> Void)?) {
        spinner.start(completion: completion)
    }

    func stop(completion: (() -> Void)?) {
        spinner.stop(completion: completion)
    }
}
