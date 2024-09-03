import Foundation
import Combine

public final class RecipeCollectionContentProps: ObservableObject, HaveInitialState {

    public let title: String
    public let recipes: [Recipe]

    public init(title: String, recipes: [Recipe]) {
        self.title = title
        self.recipes = recipes
    }

    public static func initial() -> Self {
        Self(title: .empty, recipes: [])
    }
}

extension RecipeCollectionContentProps: Equatable {
    public static func == (lhs: RecipeCollectionContentProps, rhs: RecipeCollectionContentProps) -> Bool {
        false // don't compare
    }
}
