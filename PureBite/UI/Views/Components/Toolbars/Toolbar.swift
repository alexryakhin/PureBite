import UIKit

// swiftlint:disable:next final_class
class Toolbar: BaseToolbar, ConfigurableView {

    // MARK: - Type Aliases

    typealias Model = Props

    // MARK: - Types

    struct Props {

        enum ItemType {
            case cancel(VoidHandler)
            case done(VoidHandler)
            case flexibleSpacer
        }

        let items: [ItemType]
    }

    // MARK: - Private Properties

    private let itemsStack = KHStack {}
    private let contentView = RSView()

    // MARK: - Lifecycle

    override func setup() {
        super.setup()
        contentView.embed(in: self)
        body().embed(in: contentView)
        contentView.backgroundStyle(.backgroundPrimary)
    }

    // MARK: - Public Methods

    public func configure(with model: Props) {
        itemsStack.removeArrangedSubviews()

        model.items.forEach {
            let view: UIView

            switch $0 {
            case .flexibleSpacer:
                view = FlexibleSpacer()
            case .cancel(let action), .done(let action):
                view = ButtonText(title: $0.title)
                    .onTap { action() }
            }

            itemsStack.addArrangedSubview(view)
        }
    }

    // MARK: - Private Methods

    private func body() -> BaseView {
        BaseBackgroundView(leftPadding: 12, right: 12, top: 18, bottom: 12) {
            KHStack { itemsStack }
        }
    }
}

extension Toolbar.Props.ItemType {
    var title: String? {
        switch self {
        case .cancel: return "Cancel"
        case .done: return "Done"
        case .flexibleSpacer: return nil
        }
    }
}
