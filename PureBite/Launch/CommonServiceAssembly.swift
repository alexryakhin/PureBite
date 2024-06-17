import Swinject
import SwinjectAutoregistration
import UIKit.UIWindow

final class CommonServiceAssembly: Assembly, Identifiable {

    let id = "CommonServiceAssembly"

    func assemble(container: Container) {

        container.register(JSONEncoder.self) { _ in
            let encoder = JSONEncoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            encoder.dateEncodingStrategy = .formatted(formatter)
            encoder.outputFormatting = .sortedKeys
            return encoder
        }.inObjectScope(.container)

        container.register(JSONDecoder.self) { _ in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = DateFormatter()

                if let date = formatter.convertStringToDate(string: dateString, format: .iso) {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm:ss") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: String(dateString.prefix(10)), formatString: "yyyy-MM-dd") {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
            return decoder
        }.inObjectScope(.container)

        container.autoregister(DeviceInfoManagerAbstract.self, initializer: DeviceInfoManager.init)
            .inObjectScope(.container)

        container.autoregister(Persistent.self, initializer: PersistentLayer.init)
            .inObjectScope(.container)

        container.autoregister(KeychainStorageAbstract.self, initializer: KeychainStorage.init)
            .inObjectScope(.container)

        container.autoregister(FeatureToggleServiceInterface.self, initializer: FeatureToggleService.init)
            .inObjectScope(.container)

        container.autoregister(NetworkServiceInterface.self, initializer: NetworkService.init)
            .inObjectScope(.container)

        container.autoregister(ServiceLayer.self, initializer: ServiceLayer.init)
            .initCompleted { _, serviceLayer in
                container.register(AppSession.self, factory: { _ in serviceLayer.session })
                    .inObjectScope(.container)
            }.inObjectScope(.container)

        container.register(SessionAbstract.self) { resolver in
            let serviceLayer = resolver ~> ServiceLayer.self
            return serviceLayer.session
        }.inObjectScope(.transient)

        container.register(SessionStorageAbstract.self) { resolver in
            SessionStorage(keychainStorage: resolver ~> KeychainStorageAbstract.self)
        }.inObjectScope(.container)

        container.register(DeepLinkService.self) { resolver in
            DeepLinkService(appSession: resolver ~> AppSession.self)
        }.inObjectScope(.container)

        container.register(SpoonacularNetworkServiceInterface.self) { resolver in
            SpoonacularNetworkService(networkService: resolver ~> NetworkServiceInterface.self)
        }.inObjectScope(.container)
    }

    func loaded(resolver: Resolver) {
        debug(String(describing: type(of: self)), "is loaded")
    }
}
