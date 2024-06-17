import UIKit

public final class MediumSpinnerHolder: BaseView {

    override public func setup() {
        super.setup()
        embed(subview: MediumSpinner(style: .dark))
    }
}

public final class RSWebView: BaseStatefullWebView<BaseView, MediumSpinnerHolder> {
}
