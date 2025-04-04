import UIKit
import Shared

/// Coordinator managing user history
public protocol CoordinatorInterface: AnyObject {

    func start()
    func open(url: String?)
    func open(url: URL)
}

public extension CoordinatorInterface {
    
    func open(url: String?) {
        guard
            let urlStr = url,
            let url = URL(string: urlStr) else {
            assertionFailure("Invalid url string")
            return
        }
        open(url: url)
    }

    func open(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

public protocol RoutableCoordinator: CoordinatorInterface {
    var router: RouterInterface { get }
}
