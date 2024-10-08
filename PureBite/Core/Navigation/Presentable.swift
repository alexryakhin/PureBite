import UIKit

/// Indicates the ability of the entity to participate in navigation
@MainActor
public protocol Presentable: AnyObject {
    
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    public func toPresent() -> UIViewController? {
        return self
    }
}
