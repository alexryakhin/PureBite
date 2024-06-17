import UIKit

public enum Presentation {
    static func present(
        modal hc: UIViewController,
        from uiViewController: UIViewController,
        animated: Bool = false,
        completion: @escaping () -> Void
    ) {
        if let topViewController = uiViewController.navigationController?.topViewController {
            topViewController.present(hc, animated: animated, completion: completion)
        } else if let modalViewController = uiViewController.presentingViewController?.presentedViewController {
            modalViewController.present(hc, animated: animated, completion: completion)
        } else if let rootViewController = uiViewController.view.window?.rootViewController {
            rootViewController.present(hc, animated: animated, completion: completion)
        }
    }

    static func dismiss(
        from uiViewController: UIViewController,
        animated: Bool = false,
        completion: @escaping () -> Void
    ) {
        if let topViewController = uiViewController.navigationController?.topViewController {
            topViewController.dismiss(animated: animated, completion: completion)
        } else if let modalViewController = uiViewController.presentingViewController?.presentedViewController {
            modalViewController.dismiss(animated: animated, completion: completion)
        } else if let rootViewController = uiViewController.view.window?.rootViewController {
            rootViewController.dismiss(animated: animated, completion: completion)
        }
    }
}
