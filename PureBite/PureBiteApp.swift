//
//  PureBiteApp.swift
//  PureBite
//
//  Created by Alexander Riakhin on 7/29/25.
//

import SwiftUI
import Firebase
import FirebaseAnalytics

@main
struct PureBiteApp: App {

    #if DEBUG
    @State private var showDebugPanel: Bool = false
    #endif

    init() {
        FirebaseApp.configure()
        setupLogger()
        setupServices()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if DEBUG
                .onShake {
                    showDebugPanel = true
                }
                .sheet(isPresented: $showDebugPanel) {
                    DebugPageView()
                }
            #endif
        }
    }
    
    private func setupLogger() {
        logger.moduleName = "PURE_BITE"
        
        let message: String
        #if DEBUG
        logger.minLogLevel = .debug
        message = "Logger level: SHOW ALL EVENTS"
        #else
        message = "SWIFT_ACTIVE_COMPILATION_CONDITIONS is not set"
        #endif
        logger.log(message, eventLevel: .important)
    }
    
    private func setupServices() {
        // Initialize singleton services here
        // Services will be initialized when first accessed
        
        // Initialize offline services
        _ = NetworkConnectivityService.shared
        _ = RecipeCacheService.shared
        _ = ImageCacheService.shared
        
        // Initialize analytics
        _ = AnalyticsService.shared
        
        // Track app lifecycle
        trackAppLifecycle()
    }
} 
