import UIKit

final class CommonToolbar: Toolbar {

    // MARK: - Public Properties

    private var onDone: VoidHandler
    private var onCancel: VoidHandler

    // MARK: - Init

    required init(onDone: @escaping VoidHandler, onCancel: @escaping VoidHandler) {
        self.onDone = onDone
        self.onCancel = onCancel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func setup() {
        super.setup()
        configure(with: .init(items: [
            .cancel({ [weak self] in self?.onCancel() }),
            .flexibleSpacer,
            .done({ [weak self] in self?.onDone() })
        ]))
    }
}
