import UIKit

public final class RoundedPageSheetController: PageSheetController {

    // MARK: - Public Properties

    public var onDone: VoidHandler?

    // MARK: - Private Properties

    private var model: RoundedPageSheetModel?

    // MARK: - Lifecycle

    public convenience init(model: RoundedPageSheetModel) {
        self.init(closeBehavior: model.closeBehavior)
        self.model = model
    }

    // MARK: - Public Methods

    override public func setup() {
        super.setup()
        topCapStyle = .rounded
        content = body()
    }

    // MARK: - Private Methods

    private func body() -> UIView {
        BaseBackgroundView(vPadding: 12, hPadding: 16) {
            KVStack(alignment: .center) {
               RSSpacer(.px36)
                ImageView(image: model?.image)
                    .tintColor(.label)
                    .size(sideLength: 72)
               RSSpacer(.px32)
                KLabel(text: model?.title)
                    .fontStyle(.title1)
                    .textAlignment(.center)
                    .multiline()
               RSSpacer(.px24)
                KLabel(text: model?.message)
                    .fontStyle(.body)
                    .textAlignment(.center)
                    .multiline()
               RSSpacer(.px68)
                ButtonPrimary(title: model?.buttonTitle)
                    .onTap { [unowned self] in
                        switch self.closeBehavior {
                        case .anyCloseAction, .onlyCloseButtonTap:
                            self.onDone?()
                        }
                    }
            }
        }
    }
}
