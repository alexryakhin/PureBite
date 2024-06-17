import Foundation

enum ErrorDisplayType {
    case page
    case snack
    case none
//    case alert
//    case window
}

protocol ErrorHandler {

    var snacksDisplay: SnacksDisplay? { get set }

    func errorReceived(_ error: Error, contentPreserved: Bool)
}
