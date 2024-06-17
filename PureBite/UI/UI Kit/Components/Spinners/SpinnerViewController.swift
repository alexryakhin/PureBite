import UIKit

public final class SpinnerViewController: ViewController {
    private let loadingActivityIndicator = LargeSpinner(style: .light)

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.label.withAlphaComponent(0.3))
        loadingActivityIndicator.embedAtCenter(of: view)
        loadingActivityIndicator.start()
    }
}
