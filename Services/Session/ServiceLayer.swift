//
//  ServiceLayer.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

import Foundation
import UIKit

public final class ServiceLayer {

    public var environment: AppEnvironment

    public let session: AppSession

    public let persistent: Persistent

    // MARK: - HostInfoProviderInterface properties

    public init(
        persistent: Persistent,
        deviceInfoManager: DeviceInfoManagerInterface
    ) {
        self.persistent = persistent
        environment = persistent.environment

        if persistent.isFirstLaunch {
            persistent.sessionStorage.flush()
        }

        session = AppSession(sessionStorage: persistent.sessionStorage)
    }

    func set(environment: AppEnvironment) {
        self.environment = environment
        persistent.set(.environment(environment))
    }
}
