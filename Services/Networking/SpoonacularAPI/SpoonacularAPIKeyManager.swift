//
//  APIKeyManager.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//

import Foundation

public protocol SpoonacularAPIKeyManagerInterface {
    /// Returns a random available API key, resetting quotas if a new day has started.
    func getRandomAvailableKey() -> APIKey?
    /// Updates the quota for the given key based on the header value.
    func updateQuota(for key: String, quotaLeft: Double)
    /// Optional helper to mark a key as exhausted immediately (quota zero).
    func markKeyExhausted(_ key: String)
}

public final class SpoonacularAPIKeyManager: SpoonacularAPIKeyManagerInterface {

    private var apiKeys: [APIKey]

    public init() {
        // Initialize all keys as unused
        self.apiKeys = Constants.mySpoonacularApiKeys
            .map { APIKey(key: $0, quotaRemaining: 150, lastUpdated: Date()) }
    }
    
    /// Returns a random available API key, resetting quotas if a new day has started.
    public func getRandomAvailableKey() -> APIKey? {
        // Reset any keys that haven't been updated today
        for index in apiKeys.indices {
            apiKeys[index].resetQuotaIfNeeded(defaultQuota: 150)
        }

        // Filter keys that are still available
        let availableKeys = apiKeys.filter { $0.isAvailable }
        return availableKeys.randomElement()
    }

    /// Updates the quota for the given key based on the header value.
    public func updateQuota(for key: String, quotaLeft: Double) {
        if let index = apiKeys.firstIndex(where: { $0.key == key }) {
            apiKeys[index].quotaRemaining = quotaLeft
            apiKeys[index].lastUpdated = Date()
            debugPrint("Updated quota for key \(key): \(quotaLeft) points left")
        }
    }

    /// Optional helper to mark a key as exhausted immediately (quota zero).
    public func markKeyExhausted(_ key: String) {
        updateQuota(for: key, quotaLeft: 0)
    }
}
