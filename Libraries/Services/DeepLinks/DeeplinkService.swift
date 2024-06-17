import Combine
import FirebaseDynamicLinks
import UIKit

public final class DeepLinkService {

    // MARK: - Types

    enum Constant {
        static let dynamicLinkHost = "com.dor.purebite"
        static let deepLinkKey = "deeplink"
    }

    // MARK: - Public Properties

    public var deepLink = CurrentValueSubject<DeepLink?, Never>(nil)

    // MARK: - Private Properties

    private let appSession: AppSession

    // MARK: - Init

    public init(appSession: AppSession) {
        self.appSession = appSession
    }

    // MARK: - Public Methods

    public func tryFindAndHandle(dynamicLink url: URL) -> Bool {
        let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)

        if let dynamicLink = dynamicLink {
            if let dynamicUrl = dynamicLink.url {
                _ = applicationDidReceiveDynamicLink(
                    dynamicUrl.absoluteString,
                    userActivityUrlString: url.absoluteString
                )
            } else {
                // Not implemented if we can't recognize deeplink
            }
            return true
        }

        return applicationDidOpenUrl(url)
    }

    public func handle(userActivity: NSUserActivity) -> Bool {
        guard let webpageURL = userActivity.webpageURL else { return false }
        let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL) { [weak self] dynamicLink, error in

            guard error == nil else {
                return fault("Received error in dynamic link - \(String(describing: error))")
            }

            guard let url = dynamicLink?.url else {
                return fault("Received nil url in dynamic link")
            }

            // Handle dynamic link value

            self?.applicationDidReceiveDynamicLink(
                url.absoluteString,
                userActivityUrlString: webpageURL.absoluteString
            )
        }
        return linkHandled
    }

    @discardableResult
    public func applicationDidOpenUrl(_ url: URL) -> Bool {
        return handleDeepLink(url: url)
    }

    @discardableResult
    public func applicationDidReceiveDynamicLink(_ linkString: String, userActivityUrlString: String) -> Bool {

        info("Received a dynamic link URL: \(linkString)")

        guard linkString.contains(Constant.dynamicLinkHost),
              let url = URL(string: linkString)
        else { return false }

        handleDeepLink(url: url)

        return true
    }

    public func tryHandleDeepLink(from payload: [AnyHashable: Any]) {
        if let key = payload.keys.first(
            where: { ($0 as? String)?.contains(Constant.deepLinkKey) ?? false }
        ),
           let urlString = payload[key] as? String,
           canOpen(urlString),
           let url = URL(string: urlString) {

            handleDeepLink(url: url)
        }
    }

    public func resetDeepLink() {
        deepLink.value = nil
    }

    // MARK: - Private Methods

    private func canOpen(_ url: String) -> Bool {
        return url.contains(Constant.dynamicLinkHost)
    }

    @discardableResult
    private func handleDeepLink(url: URL) -> Bool {
        info("Trying to handle deep link: \(url)")

        switch url.scheme {
        default:
            guard canOpen(url.absoluteString) else { return false }
            DeepLink.Endpoint.allCases.forEach { endpoint in
                if url.absoluteString.contains(endpoint.endpoint) {
                    let queryParams = url.queryParams()
                    do {
                        let deepLink = try DeepLink.getDeepLink(from: endpoint, with: queryParams)
                        self.deepLink.send(deepLink)
                    } catch {
                        switch error {
                        case DeepLink.DeepLinkError.invalidParams:
                            fault("Invalid deeplink params passed to universal link")
                        default:
                            fault("Unexpected error while parsing universal link")
                        }
                    }
                }
            }
        }
        return false
    }
}
