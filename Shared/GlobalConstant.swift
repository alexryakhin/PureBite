//
//  GlobalConstant.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/29/24.
//

import UIKit

enum GlobalConstant {

    static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
