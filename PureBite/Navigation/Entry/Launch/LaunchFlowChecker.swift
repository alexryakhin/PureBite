//
//  LaunchFlowChecker.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//
import Combine

public enum Flow {

#if DEBUG
    case developerHome
#endif
    case auth
    case entrance
    case home
}

public protocol LaunchFlowCheckerInterface: AnyObject {

#if DEBUG
    var overriddenFlow: Flow? { get set }
#endif
    func flowToLaunch() -> Flow
}

final public class LaunchFlowChecker: LaunchFlowCheckerInterface {

    private let session: AppSession

#if DEBUG
    public var developerHomeShownAlready = false
    public var overriddenFlow: Flow?
#endif

    public init(session: AppSession) {
        self.session = session
    }

    public func flowToLaunch() -> Flow {
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
