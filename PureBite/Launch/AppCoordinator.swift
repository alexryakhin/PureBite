import UIKit
import Combine
import Swinject
import SwinjectAutoregistration

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
#if DEBUG
    let router: RouterAbstract
#else
    private let router: RouterAbstract
#endif

#if DEBUG
    let resolver: Resolver
#else
    private let resolver: Resolver
#endif
    private let persistent: Persistent
#if DEBUG
    let launchChecker: LaunchFlowCheckerAbstract
#else
    private let launchChecker: LaunchFlowCheckerAbstract
#endif

    private lazy var appSession = resolver ~> AppSession.self
    private lazy var deepLinkService = resolver ~> DeepLinkService.self

    private var cancellables = Set<AnyCancellable>()

    var isLogged = false

    var incomingActivity: NSUserActivity?

    #if DEBUG
    var firstStart = true
    #else
    var firstStart = false
    #endif

    init(
        window: UIWindow,
        router: Router
    ) {
        self.window = window
        self.router = router

        resolver = DIContainer.shared.resolver

        persistent = resolver ~> Persistent.self
        launchChecker = resolver ~> LaunchFlowCheckerAbstract.self

        super.init()

        // Only after checking first launch!
        saveLastUsedAppVersion()

        if window.isKeyWindow == false {
            window.rootViewController = router.rootController
            window.makeKeyAndVisible()
        }

        #if DEBUG
        setupDebugToolkit()
        #endif

        registerAssemblies()
        setupBindings()
    }

    override func start() {
        debug("AppCoordinator start")

        if let deeplink = incomingActivity {
            incomingActivity = nil
            _ = deepLinkService.handle(userActivity: deeplink)
        }

        // FIXME: - Fix working with deep links in CoreNavigation
        // Using basic start() method instead of
        // start(with deeplink) because cant override it
        if let deepLink = deepLinkService.deepLink.value {
            handle(deepLink: deepLink)
            deepLinkService.resetDeepLink()
        } else {
            switch launchChecker.flowToLaunch() {
    #if DEBUG
            case .developerHome:
                showDebugRoutingScreen()
    #endif
            case .entrance:
                runEntranceFlow()
            case .auth:
                runAuthFlow()
            case .home:
                runHomeFlow()
            }
        }
    }

    #if DEBUG
    private func setupDebugToolkit() {
        DebugToolkit(navigationDelegate: self).setup()
    }
    #endif

    private func saveLastUsedAppVersion() {
        if let appVersion = GlobalConstant.appVersion {
            persistent.set(.lastUsedAppVersion(appVersion))
        }
    }

    private func handle(deepLink: DeepLink) {
        // TODO: - Check if deeplink requires auth
        // Maybe put this AppSession handle into deeplink service?
        switch deepLink {
        case .resetPassword(let token):
            if appSession.isLoggedIn {
                appSession.resetWithoutTriggeringLogout()
            }
            appSession.set(
                tokens: .init(accessToken: token, refreshToken: "", logoutToken: "")
            )
            runAuthFlow(with: deepLink)
        case .editProfile:
            break
        case .signInFromProfile:
            runAuthFlow(with: deepLink)
        case .applicationStatus:
            break
        }
    }

    func runAuthFlow(with deepLink: DeepLink? = nil) {
        if let existingAuthCoordinator = child(ofType: AuthCoordinator.self) {
            if let deepLink {
                existingAuthCoordinator.handle(deepLink: deepLink)
            } else {
                existingAuthCoordinator.start()
            }
            return
        }

        let authCoordinator = resolver ~> (AuthCoordinator.self, argument: router)

        authCoordinator.onEvent = { [weak self, weak authCoordinator] event in
            switch event {
            case .finish:
                if authCoordinator?.shouldBePopped == true {
                    DispatchQueue.main.async {
                        authCoordinator?.popToHome()
                        self?.removeDependency(authCoordinator)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.runHomeFlow()
                        self?.removeDependency(authCoordinator)
                    }
                }
            }
        }

        addDependency(authCoordinator)
        authCoordinator.start(with: deepLink)
    }

    func runEntranceFlow() {
        if let existingEntranceCoordinator = child(ofType: EntranceCoordinator.self) {
            existingEntranceCoordinator.start()
            return
        }

        DIContainer.shared.assemble(assembly: EntranceAssembly())
        let entranceCoordinator = resolver ~> (EntranceCoordinator.self, argument: router)

        addDependency(entranceCoordinator)

        entranceCoordinator.onEvent = { [weak self] event in
            switch event {
            case .successLoggingIn:
                self?.runHomeFlow()
            case .failureLoggingIn:
                self?.runAuthFlow()
            case .logOut:
                self?.runAuthFlow()
            }
        }

        entranceCoordinator.start()
    }

    func runHomeFlow() {
        if let existingHomeCoordinator = child(ofType: HomeCoordinator.self) {
            existingHomeCoordinator.start()
            return
        }

        DIContainer.shared.assemble(assembly: HomeAssembly())
        let homeCoordinator = resolver ~> (HomeCoordinator.self, argument: router)

        homeCoordinator.onEvent = { [weak self] event in
            switch event {
            case .authorize:
                self?.handle(deepLink: .signInFromProfile)
            }
        }

        addDependency(homeCoordinator)

        homeCoordinator.start()
    }

    private func registerAssemblies() {
        DIContainer.shared.assemble(assembly: AuthAssembly())
    }

    private func setupBindings() {
        deepLinkService.deepLink
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deeplink in
                guard let deeplink else { return }
                // Return this upcoming deeplink when start with deeplink fixed
                // self?.upcomingDeeplink = deeplink as? DeeplinkAbstract
                self?.start()
            }
            .store(in: &cancellables)
    }
}
