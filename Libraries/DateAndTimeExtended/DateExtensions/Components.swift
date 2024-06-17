import Foundation

// MARK: - Extracting components

public extension Date {

    func year(
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return componentValue(.year, calendar: calendar)
    }

    func month(
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return componentValue(.month, calendar: calendar)
    }

    func day(
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return componentValue(.day, calendar: calendar)
    }

    func minute(
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return componentValue(.minute, calendar: calendar)
    }

    func second(
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return componentValue(.second, calendar: calendar)
    }

    func componentValue(
        _ component: Calendar.Component,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Int? {
        return calendar.dateComponents([component], from: self).value(for: component)
    }

    func allDateComponents(
        calendar: Calendar = .autoupdatingCurrent
    ) -> DateComponents {
        return calendar.dateComponents(
            Calendar.Component.allComponents,
            from: self
        )
    }
}

public extension Calendar.Component {

    static var allComponents: Set<Calendar.Component> {
        [
            .year,
            .month,
            .day,
            .weekOfYear,
            .hour,
            .minute,
            .second,
            .weekday,
            .weekdayOrdinal,
            .weekOfYear
        ]
    }
}
