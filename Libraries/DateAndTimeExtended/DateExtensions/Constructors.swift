import Foundation

public extension Date {

    init?(
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        calendar: Calendar = .current
    ) {
        var dateComponents = DateComponents()

        if let year {
            dateComponents.year = year
        }
        if let month {
            dateComponents.month = month
        }
        if let day {
            dateComponents.day = day
        }
        if let hour {
            dateComponents.hour = hour
        }
        if let minute {
            dateComponents.minute = minute
        }
        if let second {
            dateComponents.second = second
        }

        if let date = Date(from: dateComponents, calendar: calendar) {
            self = date
        } else {
            return nil
        }
    }

    init?(
        from dateComponents: DateComponents,
        ignoreDefaultTimeZone: Bool = true,
        calendar: Calendar = .current
    ) {
        var dateComponentsCopy = dateComponents
        if ignoreDefaultTimeZone {
            dateComponentsCopy.timeZone = TimeZone(secondsFromGMT: 0)
        }

        if let date = calendar.date(from: dateComponentsCopy) {
            self = date
        } else {
            return nil
        }
    }
}
