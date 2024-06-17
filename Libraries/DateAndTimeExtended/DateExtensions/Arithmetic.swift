import Foundation

public extension Date {

    /// Offsets a date component with a +/- value
    func adding(
        _ component: Calendar.Component,
        value: Int,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(value, for: component)

        let resultDate = calendar.date(
            byAdding: dateComponents,
            to: self
        )

        if resultDate == nil {
            assertionFailure("Unexpectedly date is nil")
        }

        return resultDate ?? Date()
    }

    func adding(
        days: Int? = nil,
        hours: Int? = nil,
        minutes: Int? = nil,
        seconds: Int? = nil,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        var dateComponents = DateComponents()
        if let days {
            dateComponents.day = days
        }
        if let hours {
            dateComponents.hour = hours
        }
        if let minutes {
            dateComponents.minute = minutes
        }
        if let seconds {
            dateComponents.second = seconds
        }

        let resultDate = calendar.date(
            byAdding: dateComponents,
            to: self
        )

        if resultDate == nil {
            assertionFailure("Unexpectedly date is nil")
        }

        return resultDate ?? Date()
    }
}
