import Foundation

public extension Date {

    func isToday(calendar: Calendar = .autoupdatingCurrent) -> Bool {
        isSameDay(as: Date())
    }

    func isTomorrow(calendar: Calendar = .autoupdatingCurrent) -> Bool {
        isSameDay(as: Date().adding(days: 1))
    }

    func isYesterday(calendar: Calendar = .autoupdatingCurrent) -> Bool {
        isSameDay(as: Date().adding(days: -1))
    }
}

public extension Date {

    func isLater(
        than date: Date,
        granularity: Calendar.Component = .second,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: granularity) {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }

    func isEarlier(
        than date: Date,
        granularity: Calendar.Component = .second,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: granularity) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
}

public extension Date {

    func isSameMonth(
        as date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: .month) {
        case .orderedSame:
            return true
        default:
            return false
        }
    }

    func isSameDay(
        as date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: .day) {
        case .orderedSame:
            return true
        default:
            return false
        }
    }

    func isSameHour(
        as date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: .hour) {
        case .orderedSame:
            return true
        default:
            return false
        }
    }

    func isSameMinute(
        as date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        switch calendar.compare(self, to: date, toGranularity: .minute) {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
