//
//  Decimal+Extension.swift
//  Pure Bite
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

extension Decimal {
    var int: Int {
        return (self as NSDecimalNumber).intValue
    }

    var double: Double {
        return (self as NSDecimalNumber).doubleValue
    }

    var string: String {
        return (self as NSDecimalNumber).stringValue
    }

    var whole: Self {
        rounded( self < 0 ? .up : .down)
    }

    var fraction: Self {
        self - whole
    }

    func rounded(_ roundingMode: NSDecimalNumber.RoundingMode = .down, scale: Int = 0) -> Self {
        var result = Self()
        var number = self
        NSDecimalRound(&result, &number, scale, roundingMode)
        return result
    }
}
