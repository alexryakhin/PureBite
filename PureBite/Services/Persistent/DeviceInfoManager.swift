import Foundation
import UIKit.UIDevice

public protocol DeviceInfoManagerAbstract: AnyObject {

    func gatherInfo() -> DeviceInfo
}

public final class DeviceInfoManager: DeviceInfoManagerAbstract {

    private let locale = Locale.current
    private let calendar = Calendar.current
    private let device = UIDevice.current

    public init() { }

    public func gatherInfo() -> DeviceInfo {
        let identifierForVendor = device.identifierForVendor?.uuidString ?? ""
        let systemVersion = device.systemVersion
        let systemName = device.systemName
        let deviceModel = device.model

        let languageCode: String
        if #available(iOS 16, *) {
            languageCode = locale.language.languageCode?.identifier ?? "ru"
        } else {
            languageCode = locale.languageCode ?? "ru"
        }
        return DeviceInfo(
            languageCode: languageCode,
            timezoneIdentifier: calendar.timeZone.identifier,
            currentFullAppVersion: currentFullAppVersion(),
            identifierForVendor: identifierForVendor,
            deviceModel: deviceModel,
            systemName: systemName,
            systemVersion: systemVersion
        )
    }

    private func currentFullAppVersion() -> String {
        String(GlobalConstant.appVersion ?? "-", GlobalConstant.buildVersion ?? "–", separator: ".")
    }
}
