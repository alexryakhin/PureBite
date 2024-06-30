import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class RecipeDetailsContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
        case favorite
    }

    let recipe: Recipe

    @Published var isLoading = false

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
