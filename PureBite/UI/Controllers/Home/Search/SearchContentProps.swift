import Foundation
import Combine

public final class SearchContentProps: ObservableObject, HaveInitialState {

    @Published var shouldActivateSearch: Bool = false
    @Published var searchTerm: String = .empty
    @Published var searchResults: [Recipe] = []
    @Published var showNothingFound: Bool = false

    public static func initial() -> Self {
        Self()
    }
}

extension SearchContentProps: Equatable {
    public static func == (lhs: SearchContentProps, rhs: SearchContentProps) -> Bool {
        false // don't compare
    }
}
