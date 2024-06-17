import Combine

public protocol Bindable: AnyObject {
    
    var cancellables: Set<AnyCancellable> { get set }
}
