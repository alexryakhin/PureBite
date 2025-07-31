//
//  Int+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import Foundation

extension Double {
    var minutesFormatted: String {
        TimeFormatter().string(seconds: self * 60, format: .hoursAndMinutes) ?? "\(self)m"
    }
}

extension Int {
    var minutesFormatted: String {
        TimeFormatter().string(seconds: TimeInterval(self * 60), format: .hoursAndMinutes) ?? "\(self)m"
    }

    var int64: Int64 {
        Int64(self)
    }
}

extension Numeric {
    @inlinable func `if`(_ condition: Bool, transform: (Self) -> Self) -> Self {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Int64 {
    var int: Int {
        Int(self)
    }
}
