import Foundation

public extension Date {

    /// Date of device with shift for timezone (this time user sees in the status bar)
    static func localDate() -> Date {
        let shift = TimeZone.current.secondsFromGMT()
        let now = Date().addingTimeInterval(TimeInterval(shift))
        return now
    }
}
