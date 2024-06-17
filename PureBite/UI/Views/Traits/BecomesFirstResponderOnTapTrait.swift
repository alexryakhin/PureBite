import UIKit
import Combine

/// If user taps `viewToTranslateTapsToFocus`, first found subview of type `UITextInput` will become first responder.
/// You should call `translateTapsToFocus()` to assign tap binding
public protocol BecomesFirstResponderOnTapTrait: AnyObject {

    var viewToTranslateTapsToFocus: UIView { get }
}

public extension BecomesFirstResponderOnTapTrait {

    func translateTapsToFocus(cancellables: inout Set<AnyCancellable>, closure: @escaping (() -> Void)) {
        viewToTranslateTapsToFocus.bindOnTaps(cancellables: &cancellables) { [weak self] in
            self?.viewToTranslateTapsToFocus.firstChild { $0 is UITextInput }?.becomeFirstResponder()
        }
    }
}

public extension BecomesFirstResponderOnTapTrait where Self: Bindable {

    func translateTapsToFocus() {
        viewToTranslateTapsToFocus.bindOnTaps(cancellables: &cancellables) { [weak self] in
            self?.viewToTranslateTapsToFocus.firstChild { $0 is UITextInput }?.becomeFirstResponder()
        }
    }
}
