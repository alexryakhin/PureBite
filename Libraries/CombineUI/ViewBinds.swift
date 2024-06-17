import Combine
import UIKit

public extension UIView {

    @discardableResult
    func bindOnTaps(cancellables: inout Set<AnyCancellable>, closure: @escaping (() -> Void)) -> Self {
        gesture(.tap()).sink { _ in
            closure()
        }.store(in: &cancellables)
        return self
    }
}

public extension Bindable where Self: UIView {

    @discardableResult
    func bindOnTaps(closure: @escaping () -> Void) -> Self {
        bindOnTaps(cancellables: &cancellables, closure: closure)
    }
}
