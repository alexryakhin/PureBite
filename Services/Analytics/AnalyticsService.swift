//
//  AnalyticsService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsService: ObservableObject {
    static let shared = AnalyticsService()
    
    private init() {}
    
    // MARK: - Generic Event Tracking
    
    func track(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
        
        let eventName = event.name
        let params = event.parameters.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        print("📊 [ANALYTICS] \(eventName) - \(params)")
    }
    
    // MARK: - Convenience Methods
    
    func trackScreen(_ screen: ScreenEvent) {
        track(screen)
    }
    
    func trackRecipe(_ event: RecipeEvent) {
        track(event)
    }
    
    func trackSearch(_ event: SearchEvent) {
        track(event)
    }
    
    func trackShoppingList(_ event: ShoppingListEvent) {
        track(event)
    }
    
    func trackCategory(_ event: CategoryEvent) {
        track(event)
    }
    
    func trackUserEngagement(_ event: UserEngagementEvent) {
        track(event)
    }
    
    func trackError(_ event: ErrorEvent) {
        track(event)
    }
    
    func trackPerformance(_ event: PerformanceEvent) {
        track(event)
    }
    
    // MARK: - User Properties
    
    func setUserProperty(_ value: String, forKey key: String) {
        Analytics.setUserProperty(value, forName: key)
        print("📊 [ANALYTICS] User property set: \(key) = \(value)")
    }
    
    func setUserID(_ userID: String) {
        Analytics.setUserID(userID)
        print("📊 [ANALYTICS] User ID set: \(userID)")
    }
} 
