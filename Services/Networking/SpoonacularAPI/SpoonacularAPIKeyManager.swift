//
//  APIKeyManager.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//

public protocol SpoonacularAPIKeyManagerInterface {
    /// Retrieve the first available API key that has not been used
    func getCurrentAPIKey() -> String?
    /// Mark the current API key as used
    func markAPIKeyAsUsed(_ key: String)
    /// Check if all API keys are exhausted
    func areAllKeysUsed() -> Bool
}

public final class SpoonacularAPIKeyManager: SpoonacularAPIKeyManagerInterface {

    /// Dictionary to store API keys and their usage status
    private var apiKeys: [String: Bool]
    
    public init() {
        // Initialize all keys as unused
        self.apiKeys = Constants.spoonacularApiKeys.reduce(into: [:]) { $0[$1] = false }
    }
    
    public func getCurrentAPIKey() -> String? {
        return apiKeys.first { !$0.value }?.key
    }
    
    public func markAPIKeyAsUsed(_ key: String) {
        apiKeys[key] = true
    }
    
    public func areAllKeysUsed() -> Bool {
        return apiKeys.values.allSatisfy { $0 }
    }
}
