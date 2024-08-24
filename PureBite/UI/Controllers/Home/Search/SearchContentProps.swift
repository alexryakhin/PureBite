import Foundation
import Combine

public final class SearchContentProps: ObservableObject, HaveInitialState {

    public static func initial() -> Self {
        Self()
    }
}

extension SearchContentProps: Equatable {
    public static func == (lhs: SearchContentProps, rhs: SearchContentProps) -> Bool {
        false // don't compare
    }
}
