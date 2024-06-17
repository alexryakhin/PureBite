#if DEBUG
import DBDebugToolkit

protocol DebugNavigationDelegate: AnyObject {}

// MARK: - Debug panel setup
final class DebugToolkit {

    weak var navigationDelegate: DebugNavigationDelegate?

    init(navigationDelegate: DebugNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }

    func setup() {
        let shakeTrigger = DBShakeTrigger()
        DBDebugToolkit.setup(with: [shakeTrigger])
        setupCustomActions()
    }
}

// MARK: - Configuring additional debug panel buttons
fileprivate extension DebugToolkit {

    func setupCustomActions() {
        DBDebugToolkit.add([
            makeFeatureTogglesScreenAction()
        ])
    }

    func makeFeatureTogglesScreenAction() -> DBCustomAction {
        return DBCustomAction(name: "Feature Toggles") {
            guard
                let window = UIApplication.currentWindow,
                let rootController = window.getCurrentTopmostViewController()
            else {
                return
            }
            rootController.present(FeatureTogglesViewController(), animated: true)
        }
    }
}
#endif
