import UIKit
import Swinject
import SwinjectAutoregistration

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var libraryManager = LibraryManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        libraryManager.setupLogger()
#if DEBUG
        info("Home directory:", NSHomeDirectory(), "\n")
#endif
        DIContainer.shared.assemble(assembly: CommonAssembly())
        DIContainer.shared.assemble(assembly: CommonServiceAssembly())

        libraryManager.setupFirebase()

        // TODO: Configure Firebase first
//        setupFeatureToggleService()

        return true
    }
    
    func setupFeatureToggleService() {
        let featureToggleService = DIContainer.shared.resolver ~> FeatureToggleServiceInterface.self
//        featureToggleService.fetchRemoteConfig()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
