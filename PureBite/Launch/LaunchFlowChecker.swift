import Combine

enum Flow {

#if DEBUG
    case developerHome
#endif
    case auth
    case entrance
    case home
}

protocol LaunchFlowCheckerAbstract: AnyObject {

#if DEBUG
    var overriddenFlow: Flow? { get set }
#endif
    func flowToLaunch() -> Flow
}

final class LaunchFlowChecker: LaunchFlowCheckerAbstract {

    private let session: AppSession

#if DEBUG
    var developerHomeShownAlready = false
    var overriddenFlow: Flow?
#endif

    init(session: AppSession) {
        self.session = session
    }

    func flowToLaunch() -> Flow {
        // Don't need it for now
//#if DEBUG
//        if let overriddenFlow {
//            return overriddenFlow
//        }
//        guard developerHomeShownAlready else {
//            developerHomeShownAlready = true
//            return .developerHome
//        }
//#endif
        // TODO: Auth flow
//        if session.isLoggedIn {
//            return .entrance
//        } else {
//            return .auth
//        }
        return .home
    }
}
