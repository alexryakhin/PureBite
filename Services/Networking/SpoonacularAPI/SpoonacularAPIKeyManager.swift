//
//  APIKeyManager.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//

import Foundation

@MainActor
final class SpoonacularAPIKeyManager: ObservableObject {
    static let shared = SpoonacularAPIKeyManager()
    
    @Published private(set) var availableKeys: [APIKey] = []
    @Published private(set) var error: Error?
    
    private var apiKeys: [APIKey]
    
    private init() {
        // Initialize all keys as unused
        self.apiKeys = Constants.mySpoonacularApiKeys
            .map { APIKey(key: $0, quotaRemaining: 150, lastUpdated: Date()) }
        self.availableKeys = apiKeys.filter { $0.isAvailable }
    }
    
    /// Returns a random available API key, resetting quotas if a new day has started.
    func getAPIKey() async throws -> String {
        // Reset any keys that haven't been updated today
        for index in apiKeys.indices {
            apiKeys[index].resetQuotaIfNeeded(defaultQuota: 150)
        }

        // Filter keys that are still available
        let availableKeys = apiKeys.filter { $0.isAvailable }
        guard let randomKey = availableKeys.randomElement() else {
            throw CoreError.networkError(.missingAPIKey)
        }
        
        self.availableKeys = availableKeys
        return randomKey.key
    }

    /// Updates the quota for the given key based on the header value.
    func updateQuotas(from headers: [String: String?], apiKey: String) async {
        if let quotaLeftStr = headers["x-api-quota-left"],
           let quotaLeftStr,
           let quotaLeft = Double(quotaLeftStr) {
            updateQuota(for: apiKey, quotaLeft: quotaLeft)
        }
    }
    
    private func updateQuota(for key: String, quotaLeft: Double) {
        if let index = apiKeys.firstIndex(where: { $0.key == key }) {
            apiKeys[index].quotaRemaining = quotaLeft
            apiKeys[index].lastUpdated = Date()
            debugPrint("Updated quota for key \(key): \(quotaLeft) points left")
            availableKeys = apiKeys.filter { $0.isAvailable }
        }
    }

    /// Optional helper to mark a key as exhausted immediately (quota zero).
    func markKeyExhausted(_ key: String) {
        updateQuota(for: key, quotaLeft: 0)
    }
}
