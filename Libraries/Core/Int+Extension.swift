//
//  Int+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import Foundation

extension Int {
    var minutesFormatted: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter.string(from: TimeInterval(self * 60)) ?? "\(self)m"
    }
}
