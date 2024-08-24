import Foundation
import Combine

public final class RecipeDetailsContentProps: ObservableObject, HaveInitialState {

    @Published var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    public static func initial() -> Self {
        Self(recipe: Recipe(id: 0, title: "Title"))
    }
}

extension RecipeDetailsContentProps: Equatable {
    public static func == (lhs: RecipeDetailsContentProps, rhs: RecipeDetailsContentProps) -> Bool {
        false // don't compare
    }
}
