//
//  OfflineBannerView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI

struct OfflineBannerView: View {
    @ObservedObject private var connectivityService = NetworkConnectivityService.shared
    
    var body: some View {
        if !connectivityService.isConnected {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                    .foregroundStyle(.white)
                
                Text("You're offline")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Some features may be limited")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .clippedWithPaddingAndBackground(.orange)
            .padding(8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

struct OfflineContentView: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 
