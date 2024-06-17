import UIKit

public final class WebViewController: BaseWebViewController<RSWebView> {

    // MARK: - Lifecycle

    public convenience init(with link: String, title: String) {
        self.init(with: link)
        setupNavigationBar(title: title)
    }

    // MARK: - Private Methods

    private func setupNavigationBar(title: String) {
        self.title = title
        navigationItem.rightBarButtonItem = CloseBarButtonItem { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
