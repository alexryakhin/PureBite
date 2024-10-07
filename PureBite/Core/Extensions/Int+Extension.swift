//
//  Int+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import Foundation

public extension Int {
    var minutesFormatted: String {
        TimeFormatter().string(seconds: TimeInterval(self * 60), format: .hoursAndMinutes) ?? "\(self)m"
    }
}

public extension Numeric {
    @inlinable func `if`(_ condition: Bool, transform: (Self) -> Self) -> Self {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
