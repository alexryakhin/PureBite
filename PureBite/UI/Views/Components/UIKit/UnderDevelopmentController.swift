import UIKit

public final class UnderDevelopmentController: ViewController {

    override public func setup() {
        super.setup()
        embed(swiftUiView: PageErrorView(props: .underDevelopment()))
    }
}
