import Foundation

public extension Date {
    var jsonFormat: String {
        DateFormatter().convertDateToString(date: self, format: .dateJson)
    }
}
