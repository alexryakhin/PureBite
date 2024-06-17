import Foundation

public protocol DateProvider {
    
    func currentDate() -> Date
}

public final class DateProviderImpl: DateProvider {

    public func currentDate() -> Date {
        return Date()
    }

    public init() { }
}
