//
//  DeviceInfo.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/29/24.
//

import Foundation

public struct DeviceInfo {
    /// Example: en
    public let languageCode: String
    /// Example: America/Los_Angeles
    public let timezoneIdentifier: String
    /// Bundle version and build number
    public let currentFullAppVersion: String
    public let identifierForVendor: String
    public let deviceModel: String
    public let systemName: String
    public let systemVersion: String
}
