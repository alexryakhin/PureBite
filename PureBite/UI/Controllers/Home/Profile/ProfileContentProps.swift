import Foundation
import Combine

public final class ProfileContentProps: ObservableObject, HaveInitialState {

    public static func initial() -> Self {
        Self()
    }
}

extension ProfileContentProps: Equatable {
    public static func == (lhs: ProfileContentProps, rhs: ProfileContentProps) -> Bool {
        false // don't compare
    }
}
