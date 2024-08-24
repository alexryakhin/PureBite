import Foundation
import Combine

public final class AuthorizeContentProps: ObservableObject, HaveInitialState {

    public static func initial() -> Self {
        Self()
    }
}

extension AuthorizeContentProps: Equatable {
    public static func == (lhs: AuthorizeContentProps, rhs: AuthorizeContentProps) -> Bool {
        false // don't compare
    }
}
