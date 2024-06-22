import Foundation
import UIKit

public final class ServiceLayer {

    public var environment: AppEnvironment

    public let session: AppSession

    public let persistent: Persistent

    // MARK: - HostInfoProviderInterface properties

    public init(
        persistent: Persistent,
        deviceInfoManager: DeviceInfoManagerAbstract
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
