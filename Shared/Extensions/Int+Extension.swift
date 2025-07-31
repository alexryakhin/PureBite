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
        if self < 60 {
            return "\(self)m"
        } else {
            let hours = self / 60
            let minutes = self % 60
            if minutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(minutes)m"
            }
        }
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
