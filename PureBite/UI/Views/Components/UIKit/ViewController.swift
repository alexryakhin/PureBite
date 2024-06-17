import UIKit
import Combine

// swiftlint:disable:next final_class
open class ViewController: BaseController, SnacksDisplay {

    var snacksPresentingAvailable: Bool = false

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        snacksPresentingAvailable = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        snacksPresentingAvailable = false
    }

    func showSnack(withConfig snackConfig: SnackView.Config) {
        if snacksPresentingAvailable {
            SnackCenter.shared.showSnack(snackConfig)
        }
    }
}
