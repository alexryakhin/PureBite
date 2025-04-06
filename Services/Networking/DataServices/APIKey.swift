//
//  APIKey.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//
import Foundation

public struct APIKey {
    let key: String
    var quotaRemaining: Double
    var lastUpdated: Date
    
    // Check if the key is available (quota > 1; or reset if a new day)
    var isAvailable: Bool {
        // If not updated today, consider it available (quota resets)
        if !Calendar.current.isDateInToday(lastUpdated) {
            return true
        }
        return quotaRemaining > 1
    }
    
    // Reset quota if it hasn't been updated today
    mutating func resetQuotaIfNeeded(defaultQuota: Double) {
        if !Calendar.current.isDateInToday(lastUpdated) {
            quotaRemaining = defaultQuota
            lastUpdated = Date()
        }
    }
}
