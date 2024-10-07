//
//  GlobalConstant.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/29/24.
//

import UIKit

public enum GlobalConstant {

    public static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
