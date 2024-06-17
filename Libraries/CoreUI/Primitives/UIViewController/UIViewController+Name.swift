import UIKit

public extension UIViewController {
    
    var className: String {
        return NSStringFromClass(classForCoder).components(separatedBy: ".").last ?? ""
    }
}
